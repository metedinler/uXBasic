def add(a, b):
    return int(a) + int(b)


def greet(name):
    return "Hello " + str(name)


def describe(values):
    return {
        "count": len(values),
        "sum": sum(values),
        "minimum": min(values),
        "maximum": max(values),
    }
