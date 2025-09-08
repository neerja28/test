import re
import sys
import os

def extract_pattern(input_string, pattern):

    # Regular expression pattern to match @mentions
    mention_pattern = re.compile(r'@[\w\.-]+(?:/[\w\.-]+)?')
    
    # Find all matches in the text
    mentions = mention_pattern.findall(input_string)

    
    # Remove duplicates by converting to a set and back to a list
    unique_mentions = list(set(mentions))
    
    return unique_mentions

def remove_mentions(mentions, to_remove):
    # Remove mentions that are in the to_remove list
    cleaned_mentions = [mention for mention in mentions if mention not in to_remove]
    return cleaned_mentions

if __name__ == "__main__":
    input_string = os.getenv('PULL_REQ_DESC')
    pattern = os.getenv('PATTERN')
    remove_fin = os.getenv('REMOVE_FIN')
    all_mentions = extract_pattern(input_string, pattern)
    print(all_mentions)
    remove_fin_mentions = remove_mentions(all_mentions,remove_fin )

    # Set the all mentions output for GitHub Actions
    with open(os.getenv('GITHUB_ENV'), 'a') as env_file:
        env_file.write(f'AT_MENTION={all_mentions}\n')

     # Set the remove fin mention output for GitHub Actions
    with open(os.getenv('GITHUB_ENV'), 'a') as env_file:
        env_file.write(f'REMOVE_FIN_MENTION={remove_fin_mentions}\n')

