<p align="center">
  <a href="https://twitter.com/checksfinance"><img src="https://avatars.githubusercontent.com/u/98661153?s=200&v=4"/></a>
</p>
<h2 align="center">
  Soul Moment
</h2>
<p align="center">
  An attempt to provide an implementation of SBT(Soul-bound token) in Cairo lang.
</p>
<p align="center">
  Brought to you by <a href="https://twitter.com/checksfinance">@ChecksFinance</a>.
</p>

<p align="center">
  <a href="https://github.com/ChecksFinance/soul-moment/">
    <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="mit license"/>
  </a>
</p>

This module is implemented on StarkNet in Cairo language. Using this module requires that you have a basic understanding of the Cairo language and python.

## Concepts

One of the most important concepts of SBT is non-transferable and verifiable split property rights. This basic logic is explored in a very simple way by implementing the issuance and verification of SBTs on L2's abstract account contracts.

### Use this module in your project

```bash
pip install git+https://github.com/ChecksFinance/soul-moment.git
```

Then

```python
from soulmoment.library import SoulMoment
```

you can find demo contracts in `./src/account` and `./src/soulmoment`

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

**Notice**: this project use the latest version of OpenZeppelin contract for Cairo instead of the stable release of it.

### ⛏️ Compile

```bash
nile compile --directory src
nile compile src/soulmoment/account/SoulAccount.cairo --account_contract
```

### 🌡️ Test

```bash
# Run all tests
pytest tests
```

## 📄 License

**soul-moment** is released under the [MIT](LICENSE).
