
import re;
from style_config import style_config
from log_feedback import log

isFunction = False
functionLength = 0
shouldNotHaveUnscopedVariablesAnyMore = False # yes, this is a long name xD
consecutiveLineBreaks = 0

def hasCamelCase(line: str):
    keyWordsToSearch = ['func', 'var', 'const']
    namesToIgnore = ['_on']
    words = line.strip().split(" ")
    for i in range(len(words)):
        if words[i] in keyWordsToSearch:
            if words[i+1] in namesToIgnore:
                continue
            if re.search(r"[a-z][A-Z]", words[i+1]) is not None:
                return True
    return False

def hasDeepNesting(line: str):
    return line.startswith("\t" * style_config["maxIndentation"])

def usesAutoType(line: str):
    if '(' in line:
        return False
    hasAutoType = re.search(r":=", line) is not None
    hasNoType = any([keyWord in line for keyWord in ["var", "const"]]) and re.search(r":", line) is None
    return hasAutoType or hasNoType

def hasBracketsOnIfStatements(line: str):
    return re.search(r"if \(", line) is not None

def hasShortVariableName(line: str):
    keyWordsToSearch = ['func', 'var', 'const']
    lineWithoutColon = line.replace(":", "")
    words = lineWithoutColon.split(" ")
    for i in range(len(words)):
        if words[i] in keyWordsToSearch:
            if len(words[i+1]) < 3 and words[i+1] != "i":
                return True
    return False

def hasTooLongFunction(line: str):
    global functionLength, isFunction, shouldNotHaveUnscopedVariablesAnyMore
    if line.startswith('func'):
        if isFunction and functionLength > style_config["maxFunctionLength"]:
            functionLength = 0
            return True
        functionLength = 0
        isFunction = True
        shouldNotHaveUnscopedVariablesAnyMore = True
    
    if isFunction:
        functionLength += 1

    return False

def hasScatteredVariableDeclaration(line: str):
    global shouldNotHaveUnscopedVariablesAnyMore
    if "func" in line:
        return False
    if shouldNotHaveUnscopedVariablesAnyMore and not line.startswith("\t"):
        return 'var' in line or 'const' in line
    return False

def hasTooLongLine(line: str):
    return len(line) > style_config["maxLineLength"] and not '@onready' in line

def missnamedBoolean(line: str):
    words = line.strip().split(" ")
    for i in range(len(words)):
        if i == 0:
            continue
        if 'bool' in words[i]:
            return not any([w in words[i-1] for w in ["is", "has", "can", "use"]])
    return False

def hasTooManyLineBreaks(line: str):
    global consecutiveLineBreaks
    if line == "\n":
        consecutiveLineBreaks += 1
    else:
        consecutiveLineBreaks = 0
    return consecutiveLineBreaks > 1

def hasOddColonFormat(line: str):
    spaceBeforeConon = re.search(r" :", line) is not None
    linesToIgnore = ["func", "if", "else", "elif", "while", "for", "match"]
    noSpaceAfeterColon = not any([x in line for x in linesToIgnore]) and line.count(":") > 0 and line[line.index(":")+1] != " " and line[line.index(":")+1] != "/"
    isDeclaration = "var" in line or "const" in line
    return isDeclaration and (spaceBeforeConon or noSpaceAfeterColon)

def hasUninitializedVariable(line: str):
    if 'var' in line:
        if not ('@export' in line or line.count(":") > 1 or line.count("(") > 0):
            return re.search(r"=", line) is None
    return False

def hasUselessIndentation(line: str):
    noBreak = line.replace("\n", "")
    return noBreak == '\t'

def hasTooManyArguments(line: str):
    if 'func' in line:
        return line.count(",")+1 > style_config["maxFunctionArguments"]
    return False

def hasSignalWithoutTypeDeclaration(line: str):
    tmpLine = line.strip()
    words = line.split(" ")
    if 'signal' in words:
        return tmpLine[-2] != "(" and tmpLine.count(":") < tmpLine.count(",")+1
    return False

checks = {
    "camelCase": hasCamelCase,
    "deep nesting": hasDeepNesting,
    "no explicit type": usesAutoType,
    "brackets on if-statements": hasBracketsOnIfStatements,
    "one-letter-variable (that is not i)": hasShortVariableName, 
    "too long function before": hasTooLongFunction,
    "too long line": hasTooLongLine,
    "missnamed boolean": missnamedBoolean, 
    "variable not at start of file": hasScatteredVariableDeclaration,
    "too many linebreaks": hasTooManyLineBreaks,
    "weird colon format": hasOddColonFormat, # var example : type = value, <- this is weird
    "uninitialized variable": hasUninitializedVariable,
    "function with too many arguments": hasTooManyArguments,
    "signal without type declaration": hasSignalWithoutTypeDeclaration
    # "useless indentation": hasUselessIndentation, # this is not working yet, it's a bit tricky
}

def resetGlobals():
    global isFunction, functionLength, shouldNotHaveUnscopedVariablesAnyMore
    isFunction = False
    functionLength = 0
    shouldNotHaveUnscopedVariablesAnyMore = False

def removeComments(line: str):
    try:
        commentIndex = line.index("#")
        return line[:commentIndex]
    except:
        return line

def checkCodeStyle(lines: list[str], filePath: str):
    resetGlobals()
    numberOfIssues = 0
    for lineNumber in range(len(lines)):
        line = removeComments(lines[lineNumber])
        for checkName in checks:
            if checks[checkName](line):
                log(checkName, filePath, lineNumber, line)
                numberOfIssues += 1

    return numberOfIssues
