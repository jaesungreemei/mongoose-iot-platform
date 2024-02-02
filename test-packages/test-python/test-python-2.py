import sys

print(sys.version_info)
if sys.version_info[0] == 2 and sys.version_info[1] == 7:
    print("Python 2.7 is installed.")
    print("Python version:", sys.version)
else:
    print("Python 2.7 is not installed or not the active version.")
