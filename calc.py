"""module creates a basic set of calculator functions to
    add, subtract, multiply, or divide 2 numbers"""

def add(nmbr1, nmbr2):
    """Add Function"""
    return nmbr1 + nmbr2


def subtract(nmbr1, nmbr2):
    """Subtract Function"""
    return nmbr1 - nmbr2


def multiply(nmbr1, nmbr2):
    """Multiply Function"""
    return nmbr1 * nmbr2


def divide(nmbr1, nmbr2):
    """Divide Function"""
    if nmbr2 == 0:
        raise ValueError('Can not divide by zero!')
    return nmbr1 / nmbr2
