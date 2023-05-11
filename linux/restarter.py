import time

def restart_server():
	try:
		print('hello')

	except Exception as e:
		print('hi')

if __name__ == '__main__':
	marker = 1
	while marker == 1:
		restart_server()
		time.sleep(10)
