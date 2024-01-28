
def log(checkName: str, filePath: str, lineNumber: int, line: str):
    print(checkName[0].upper() + checkName[1:] + ":")
    print("    Filepath: " + filePath.replace("game/", ""))
    print("    Line: " + str(lineNumber+1))
    print("    " + line.strip())
    print("")