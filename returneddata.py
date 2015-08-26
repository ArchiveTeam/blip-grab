import requests
import sys

def main():
	url = sys.argv[1]
	response = requests.get(url, headers = {'User-Agent': 'ArchiveTeam'}, stream=True)
	with open('returned', 'w') as file:
		for filepart in response.iter_content(chunk_size=1):
			file.write('True')
			sys.exit()
		file.write('False')

if __name__ == '__main__':
    main()
