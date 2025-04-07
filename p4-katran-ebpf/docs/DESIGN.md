
```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y clang llvm libpcap-dev python3-scapy
          
      - name: Build P4 program
        run: |
          chmod +x scripts/build.sh
          ./scripts/build.sh
          
      - name: Run tests
        run: |
          cd src/tests
          python3 test_katran.py
