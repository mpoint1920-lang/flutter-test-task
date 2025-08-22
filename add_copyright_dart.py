import os

# Define the new copyright notice
copyright_notice = """\
// ******************************************************
// Originally Written by Yeabsera Mekonnen
// github.com/yabeye
// For the purpose of a Flutter Todo App candidate testing
// Anyone can use part or full of this code freely
// Date: August, 2025
// ******************************************************
"""

# Specify the file extension to target
target_extension = ".dart"

# Function to prepend copyright to Dart files
def add_copyright_to_dart_files(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(target_extension):
                filepath = os.path.join(root, file)
                with open(filepath, "r+", encoding="utf-8") as f:
                    content = f.read()
                    if copyright_notice.strip() not in content:
                        f.seek(0)
                        f.write(copyright_notice + "\n" + content)
                        print(f"Updated: {filepath}")

# Run the script in the current directory
add_copyright_to_dart_files(".")
