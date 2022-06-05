# Soul Moment

### Set up the project

#### Create a Python virtual environment

```bash
python -m venv env
source env/bin/activate
```

#### 📦 Install the requirements

```bash
pip install -r requirements.txt
```

Then, install the latest version of OZ contract for Cairo:

```bash
pip install git+https://github.com/OpenZeppelin/cairo-contracts.git
```

### ⛏️ Compile

```bash
nile compile
```

### 🌡️ Test

```bash
# Run all tests
pytest tests
```

## 📄 License

**soul-moment** is released under the [MIT](LICENSE).
