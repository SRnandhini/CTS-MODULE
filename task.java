import java.io.*;
import java.net.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.*;

public class JavaMasterApp {

    static Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {
        while (true) {
            System.out.println("\nJava Master App - Select an Exercise (1-41), 0 to Exit:");
            int choice = sc.nextInt();
            sc.nextLine(); // consume newline

            switch (choice) {
                case 0 -> System.exit(0);
                case 1 -> System.out.println("Hello, World!");
                case 2 -> calculator();
                case 3 -> evenOdd();
                case 4 -> leapYear();
                case 5 -> multiplicationTable();
                case 6 -> dataTypes();
                case 7 -> typeCasting();
                case 8 -> operatorPrecedence();
                case 9 -> gradeCalculator();
                case 10 -> guessingGame();
                case 11 -> factorial();
                case 12 -> methodOverloading();
                case 13 -> fibonacci();
                case 14 -> arraySumAvg();
                case 15 -> reverseString();
                case 16 -> palindromeCheck();
                case 17 -> carClass();
                case 18 -> inheritanceExample();
                case 19 -> interfaceExample();
                case 20 -> tryCatchDemo();
                case 21 -> customExceptionDemo();
                case 22 -> writeFile();
                case 23 -> readFile();
                case 24 -> arrayListDemo();
                case 25 -> hashMapDemo();
                case 26 -> threadDemo();
                case 27 -> lambdaSort();
                case 28 -> streamEvenNumbers();
                case 29 -> recordsDemo();
                case 30 -> patternMatchingSwitch();
                case 31 -> jdbcSelect();
                case 32 -> jdbcInsertUpdate();
                case 33 -> jdbcTransaction();
                case 34 -> System.out.println("Modules must be compiled via module path (not shown here).");
                case 35 -> tcpChatServer();
                case 36 -> httpClientDemo();
                case 37 -> System.out.println("Use `javap -c ClassName` in terminal.");
                case 38 -> System.out.println("Use JD-GUI to decompile .class file.");
                case 39 -> reflectionDemo();
                case 40 -> virtualThreadsDemo();
                case 41 -> executorCallableDemo();
                default -> System.out.println("Invalid choice.");
            }
        }
    }

    // Sample Method Implementations (For brevity, only a few are implemented here)

    static void calculator() {
        System.out.print("Enter two numbers: ");
        double a = sc.nextDouble(), b = sc.nextDouble();
        System.out.print("Operation (+ - * /): ");
        char op = sc.next().charAt(0);
        double result = switch (op) {
            case '+' -> a + b;
            case '-' -> a - b;
            case '*' -> a * b;
            case '/' -> b != 0 ? a / b : Double.NaN;
            default -> 0;
        };
        System.out.println("Result: " + result);
    }

    static void evenOdd() {
        System.out.print("Enter a number: ");
        int n = sc.nextInt();
        System.out.println(n % 2 == 0 ? "Even" : "Odd");
    }

    static void leapYear() {
        System.out.print("Enter year: ");
        int year = sc.nextInt();
        boolean isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
        System.out.println(isLeap ? "Leap year" : "Not a leap year");
    }

    static void multiplicationTable() {
        System.out.print("Enter a number: ");
        int n = sc.nextInt();
        for (int i = 1; i <= 10; i++) System.out.println(n + " x " + i + " = " + (n * i));
    }

    static void dataTypes() {
        int i = 10;
        float f = 3.14f;
        double d = 9.81;
        char c = 'A';
        boolean b = true;
        System.out.printf("int: %d, float: %.2f, double: %.2f, char: %c, boolean: %b%n", i, f, d, c, b);
    }

    static void typeCasting() {
        double d = 9.99;
        int i = (int) d;
        int x = 5;
        double y = x;
        System.out.println("Double to Int: " + i + ", Int to Double: " + y);
    }

    static void operatorPrecedence() {
        int result = 10 + 5 * 2;
        System.out.println("10 + 5 * 2 = " + result + " (Multiplication first)");
    }

    static void gradeCalculator() {
        System.out.print("Enter marks: ");
        int marks = sc.nextInt();
        char grade = (marks >= 90) ? 'A' : (marks >= 80) ? 'B' : (marks >= 70) ? 'C' : (marks >= 60) ? 'D' : 'F';
        System.out.println("Grade: " + grade);
    }

    // --- Remaining 30+ methods would follow similarly with appropriate logic ---

    // You can request any of the remaining ones, or I can continue and generate all in next response.

}
