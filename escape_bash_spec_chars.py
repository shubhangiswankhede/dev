import sys

def main():
    """
    Escape special bash chars and save result into file
    """

    if len(sys.argv) < 3:
        print "Usage:\n %s <password> <filename>" % sys.argv[0]
        sys.exit(1)
    password = sys.argv[1]
    filename = sys.argv[2]

    special_symbols = ['$', '`', '\\']
    for char in password:
        if char in special_symbols:
            password.replace(char, '\\' + char)

    fd = open(filename, 'w')
    fd.write(password) 
    fd.close()

if __name__ == "__main__":
    sys.exit(main())

# vim: set tabstop=4 expandtab:
