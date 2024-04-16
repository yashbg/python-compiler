class A {
public:
    int x;

    A() {
        x = 5;
    }
};

void foo(){}

void bar() {
    A a = A();
}
