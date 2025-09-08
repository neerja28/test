import re
import sys
import os

def extract_pattern(input_string, pattern):
    # Regex to match the pattern until the end of the line
    pattern_regex = re.compile(pattern + r'.*')
    print(pattern)
    matches = pattern_regex.findall(input_string)
    return matches

def strip_by_token(pattern_val, token):
    part = pattern_val[0].split(token, 1)
    if len(part) > 1:
        print(part)
        return part[1].strip()  # Return the part after the token, stripping leading/trailing whitespace
    return None

if __name__ == "__main__":
    input_string = os.getenv('PULL_REQ_DESC')
    pattern = os.getenv('PATTERN')
    pattern_value = extract_pattern(input_string, pattern)
    print(pattern_value)
    pattern_val = os.getenv('PATTERN_VAL', pattern_value)
    token = os.getenv('TOKEN', ':')
    # pattern_str = [part.strip() for part in pattern_val]
    extracted_value = strip_by_token(pattern_val, token)
    print(extracted_value)

    # Set the output for GitHub Actions
    with open(os.getenv('GITHUB_ENV'), 'a') as env_file:
        env_file.write(f'EXTRACTED_VALUE={extracted_value}\n')
