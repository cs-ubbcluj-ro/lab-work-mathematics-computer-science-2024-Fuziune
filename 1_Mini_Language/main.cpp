
struct Point {
    int x;
    int y;
};
int main() {
    int k;
    int count = 0;
    int num = 2;

    cout << "Enter number of primes: ";
    cin >> k;

    Point p;
    p.x = 0;
    p.y = 0;

    while (count < k) {
        bool isPrime = true;

        int i = 2;
        while (i * i <= num) {
            if (num % i == 0) {
                isPrime = false;
                break;
            }
            i = i + 1;
        }

        if (isPrime == true) {
            cout << num << " ";
            count = count + 1;
        }

        num = num + 1;
    }

    return 0;
}
