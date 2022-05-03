from dectect import show_result, show_classification
from myClassifier import classify
from utils import make_data


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press Strg+F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi('PyCharm')
    #make_data()
    #classify()
    #show_result()
    show_classification('eiche.jpg')
