# java-oop-project

A Java project with package: `tp3.exercice4`

## Structure

```
java-oop-project/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── tp3/exercice4/
│   │           └── Main.java
│   └── test/
│       └── java/
├── target/       (compiled classes)
├── lib/          (external libraries)
├── pom.xml       (Maven project file)
└── .gitignore
```

## How to Run

Use the project-specific run script:
```bash
./run.sh
```

Or use the global script:
```bash
../run-java-project.sh
```

Or manually:
```bash
javac -d target/classes src/main/java/**/*.java
java -cp target/classes tp3.exercice4.Main
```

## Adding Packages

Use the project-specific script:
```bash
./add-package.sh
```

Or use the global script:
```bash
../add-package.sh
```
