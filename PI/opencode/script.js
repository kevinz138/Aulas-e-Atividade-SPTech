const resultEl = document.getElementById('result');
const historyEl = document.getElementById('history');
const angleBadge = document.getElementById('angleBadge');
const memoryBadge = document.getElementById('memoryBadge');
const calculatorEl = document.getElementById('calculator');
const scientificKeypad = document.getElementById('scientificKeypad');
const modeButtons = document.querySelectorAll('.mode-btn');

let current = '0';
let previous = null;
let operator = null;
let waitingForOperand = false;
let expMode = false;
let expStr = '';
let sciNotation = false;
let angleMode = 'deg';
let memory = 0;
let hasMemory = false;
let errorState = false;
let scientificMode = false;

const OPERATOR_SYMBOLS = {
  '+': '+',
  '-': '−',
  '×': '×',
  '÷': '÷',
  'x^y': '^',
  'y√x': 'y√x',
  'mod': 'Mod',
};

function formatExp(value) {
  let text = value.toExponential(9);
  text = text.replace(/(\.\d*?)0+e/, '$1e');
  text = text.replace(/\.e/, 'e');
  return text;
}

function formatResult(value) {
  if (typeof value !== 'number' || Number.isNaN(value)) return 'Erro';
  if (!Number.isFinite(value)) return value > 0 ? '∞' : '−∞';
  const rounded = parseFloat(value.toPrecision(12));
  if (sciNotation) return formatExp(rounded);
  const abs = Math.abs(rounded);
  if (abs !== 0 && (abs >= 1e15 || abs < 1e-9)) return formatExp(rounded);
  return String(rounded);
}

function updateDisplay() {
  let text = current;
  if (expMode) text = current + 'e' + (expStr === '' ? '' : expStr);
  resultEl.textContent = text;
  if (text.length <= 10) resultEl.style.fontSize = '';
  else if (text.length <= 14) resultEl.style.fontSize = '32px';
  else resultEl.style.fontSize = '25px';
  memoryBadge.hidden = !hasMemory;
  angleBadge.hidden = !scientificMode;
  angleBadge.textContent = angleMode === 'deg' ? 'Deg' : 'Rad';
}

function setHistory(text) {
  historyEl.textContent = text;
}

function allClear() {
  current = '0';
  previous = null;
  operator = null;
  waitingForOperand = false;
  expMode = false;
  expStr = '';
  errorState = false;
  setHistory('');
  updateDisplay();
}

function clearEntry() {
  current = '0';
  expMode = false;
  expStr = '';
  errorState = false;
  updateDisplay();
}

function showError() {
  errorState = true;
  current = 'Erro';
  previous = null;
  operator = null;
  waitingForOperand = false;
  expMode = false;
  expStr = '';
  setHistory('');
  updateDisplay();
}

function inputDigit(digit) {
  if (errorState) allClear();
  if (expMode) {
    if (expStr.replace('-', '').length >= 3) return;
    if (digit === '0' && (expStr === '' || expStr === '-')) return;
    expStr += digit;
    updateDisplay();
    return;
  }
  if (waitingForOperand) {
    current = digit;
    waitingForOperand = false;
  } else if (current === '0' || current === '-0') {
    current = current.startsWith('-') ? '-' + digit : digit;
  } else if (current.replace(/[^0-9]/g, '').length < 15) {
    current += digit;
  } else {
    return;
  }
  updateDisplay();
}

function inputDot() {
  if (errorState) allClear();
  if (expMode) return;
  if (waitingForOperand) {
    current = '0.';
    waitingForOperand = false;
  } else if (!current.includes('.')) {
    current += '.';
  }
  updateDisplay();
}

function negate() {
  if (errorState) return;
  if (expMode) {
    expStr = expStr.startsWith('-') ? expStr.slice(1) : '-' + expStr;
    updateDisplay();
    return;
  }
  if (current === '0') current = '-0';
  else current = current.startsWith('-') ? current.slice(1) : '-' + current;
  updateDisplay();
}

function backspace() {
  if (errorState) {
    allClear();
    return;
  }
  if (expMode) {
    expStr = expStr.slice(0, -1);
    if (expStr === '' || expStr === '-') {
      expMode = false;
      expStr = '';
    }
    updateDisplay();
    return;
  }
  if (waitingForOperand) return;
  current = current.length > 1 ? current.slice(0, -1) : '0';
  if (current === '-') current = '0';
  updateDisplay();
}

function collapseExp() {
  if (!expMode) return;
  const mantissa = parseFloat(current);
  const exponent = parseInt(expStr === '' || expStr === '-' ? '0' : expStr, 10);
  current = formatResult(mantissa * Math.pow(10, exponent));
  expMode = false;
  expStr = '';
}

function startExp() {
  if (errorState) allClear();
  if (expMode) return;
  expMode = true;
  expStr = '';
  updateDisplay();
}

function compute(a, b, op) {
  switch (op) {
    case '+': return a + b;
    case '-': return a - b;
    case '×': return a * b;
    case '÷': return b === 0 ? null : a / b;
    case 'mod': return b === 0 ? null : a % b;
    case 'x^y': return Math.pow(a, b);
    case 'y√x': {
      if (b === 0) return null;
      if (a < 0) {
        if (Number.isInteger(b) && b % 2 !== 0) return -Math.pow(-a, 1 / b);
        return null;
      }
      return Math.pow(a, 1 / b);
    }
    default: return null;
  }
}

function setOperator(op) {
  if (errorState) return;
  collapseExp();
  const inputValue = parseFloat(current);
  if (operator !== null && !waitingForOperand) {
    const result = compute(previous, inputValue, operator);
    if (result === null || Number.isNaN(result)) return showError();
    previous = result;
    current = formatResult(result);
    updateDisplay();
  } else if (previous === null) {
    previous = inputValue;
  }
  operator = op;
  waitingForOperand = true;
  setHistory(formatResult(previous) + ' ' + OPERATOR_SYMBOLS[op]);
}

function equals() {
  if (errorState) return;
  if (operator === null) return;
  collapseExp();
  const inputValue = parseFloat(current);
  const result = compute(previous, inputValue, operator);
  if (result === null || Number.isNaN(result)) return showError();
  setHistory(formatResult(previous) + ' ' + OPERATOR_SYMBOLS[operator] + ' ' + formatResult(inputValue) + ' =');
  current = formatResult(result);
  previous = result;
  operator = null;
  waitingForOperand = true;
  updateDisplay();
}

function percent() {
  if (errorState) return;
  collapseExp();
  const value = parseFloat(current);
  let result = value / 100;
  if (operator !== null && !waitingForOperand && previous !== null && (operator === '+' || operator === '-')) {
    result = previous * value / 100;
  }
  current = formatResult(result);
  waitingForOperand = true;
  updateDisplay();
}

function applyUnary(name) {
  if (errorState) return;
  collapseExp();
  const value = parseFloat(current);
  const toRad = (v) => angleMode === 'deg' ? v * Math.PI / 180 : v;
  const fromRad = (v) => angleMode === 'deg' ? v * 180 / Math.PI : v;
  let result;
  let label = name;
  let ok = true;
  switch (name) {
    case 'sqrt':
      ok = value >= 0;
      result = Math.sqrt(value);
      label = '√(' + formatResult(value) + ')';
      break;
    case 'square':
      result = value * value;
      label = 'sqr(' + formatResult(value) + ')';
      break;
    case 'cube':
      result = value * value * value;
      label = 'cube(' + formatResult(value) + ')';
      break;
    case 'reciprocal':
      ok = value !== 0;
      result = 1 / value;
      label = '1/(' + formatResult(value) + ')';
      break;
    case 'factorial':
      ok = value >= 0 && Number.isInteger(value) && value <= 170;
      result = 1;
      for (let i = 2; i <= value; i++) result *= i;
      label = formatResult(value) + '!';
      break;
    case 'sin':
      result = Math.sin(toRad(value));
      label = 'sin(' + formatResult(value) + ')';
      break;
    case 'cos':
      result = Math.cos(toRad(value));
      label = 'cos(' + formatResult(value) + ')';
      break;
    case 'tan':
      result = Math.tan(toRad(value));
      label = 'tan(' + formatResult(value) + ')';
      break;
    case 'asin':
      ok = value >= -1 && value <= 1;
      result = fromRad(Math.asin(value));
      label = 'sin⁻¹(' + formatResult(value) + ')';
      break;
    case 'acos':
      ok = value >= -1 && value <= 1;
      result = fromRad(Math.acos(value));
      label = 'cos⁻¹(' + formatResult(value) + ')';
      break;
    case 'atan':
      result = fromRad(Math.atan(value));
      label = 'tan⁻¹(' + formatResult(value) + ')';
      break;
    case 'sinh':
      result = Math.sinh(toRad(value));
      label = 'sinh(' + formatResult(value) + ')';
      break;
    case 'tanh':
      result = Math.tanh(toRad(value));
      label = 'tanh(' + formatResult(value) + ')';
      break;
    case 'ln':
      ok = value > 0;
      result = Math.log(value);
      label = 'ln(' + formatResult(value) + ')';
      break;
    case 'log':
      ok = value > 0;
      result = Math.log10(value);
      label = 'log(' + formatResult(value) + ')';
      break;
    case 'exp':
      result = Math.exp(value);
      label = 'e^(' + formatResult(value) + ')';
      break;
    case 'exp10':
      result = Math.pow(10, value);
      label = '10^(' + formatResult(value) + ')';
      break;
    default:
      ok = false;
  }
  if (!ok || result === undefined || Number.isNaN(result)) return showError();
  setHistory(label + ' =');
  if (operator === null || waitingForOperand) previous = result;
  current = formatResult(result);
  waitingForOperand = true;
  updateDisplay();
}

function inputConstant(name) {
  if (errorState) allClear();
  const value = name === 'pi' ? Math.PI : Math.E;
  current = formatResult(value);
  waitingForOperand = true;
  updateDisplay();
}

function inputRandom() {
  if (errorState) allClear();
  current = formatResult(Math.random());
  waitingForOperand = true;
  updateDisplay();
}

function memoryAction(action) {
  if (errorState) return;
  collapseExp();
  const value = parseFloat(current);
  switch (action) {
    case 'mc':
      memory = 0;
      hasMemory = false;
      break;
    case 'mr':
      current = formatResult(memory);
      waitingForOperand = true;
      break;
    case 'ms':
      memory = value;
      hasMemory = true;
      break;
    case 'mplus':
      memory = value + memory;
      hasMemory = true;
      break;
    case 'mminus':
      memory = memory - value;
      hasMemory = true;
      break;
  }
  updateDisplay();
}

function toggleAngle() {
  angleMode = angleMode === 'deg' ? 'rad' : 'deg';
  const degButton = document.querySelector('[data-action="deg"]');
  degButton.textContent = angleMode === 'deg' ? 'Deg' : 'Rad';
  degButton.classList.toggle('active', angleMode === 'rad');
  updateDisplay();
}

function toggleNotation() {
  sciNotation = !sciNotation;
  const feButton = document.querySelector('[data-action="fe"]');
  feButton.classList.toggle('active', sciNotation);
  if (!expMode && !errorState) {
    const value = parseFloat(current);
    if (!Number.isNaN(value)) current = formatResult(value);
  }
  updateDisplay();
}

function handleAction(action) {
  switch (action) {
    case 'backspace': backspace(); break;
    case 'clearEntry': clearEntry(); break;
    case 'clear': allClear(); break;
    case 'negate': negate(); break;
    case 'percent': percent(); break;
    case 'dot': inputDot(); break;
    case 'equals': equals(); break;
    case 'ee': startExp(); break;
    case 'fe': toggleNotation(); break;
    case 'deg': toggleAngle(); break;
    case 'rand': inputRandom(); break;
  }
}

document.querySelector('.keypads').addEventListener('click', (event) => {
  const button = event.target.closest('button');
  if (!button) return;
  if (button.dataset.digit !== undefined) {
    inputDigit(button.dataset.digit);
  } else if (button.dataset.action) {
    handleAction(button.dataset.action);
  } else if (button.dataset.operator) {
    setOperator(button.dataset.operator);
  } else if (button.dataset.unary) {
    applyUnary(button.dataset.unary);
  } else if (button.dataset.constant) {
    inputConstant(button.dataset.constant);
  } else if (button.dataset.memory) {
    memoryAction(button.dataset.memory);
  }
});

modeButtons.forEach((button) => {
  button.addEventListener('click', () => {
    modeButtons.forEach((b) => b.classList.toggle('active', b === button));
    scientificMode = button.dataset.mode === 'scientific';
    scientificKeypad.hidden = !scientificMode;
    calculatorEl.classList.toggle('scientific-mode', scientificMode);
    updateDisplay();
  });
});

document.addEventListener('keydown', (event) => {
  const key = event.key;
  if (key >= '0' && key <= '9') {
    inputDigit(key);
  } else if (key === '.' || key === ',') {
    inputDot();
  } else if (key === '+') {
    setOperator('+');
  } else if (key === '-') {
    setOperator('-');
  } else if (key === '*') {
    setOperator('×');
  } else if (key === '/') {
    event.preventDefault();
    setOperator('÷');
  } else if (key === '%') {
    percent();
  } else if (key === 'Enter' || key === '=') {
    event.preventDefault();
    equals();
  } else if (key === 'Backspace') {
    backspace();
  } else if (key === 'Escape') {
    allClear();
  } else if (key === '^') {
    setOperator('x^y');
  } else if (key === '!') {
    applyUnary('factorial');
  } else if (key === 'r' || key === 'R') {
    applyUnary('reciprocal');
  } else if (key === '@') {
    applyUnary('sqrt');
  } else if (key === 'p' || key === 'P') {
    inputConstant('pi');
  } else if (key === 'x' || key === 'X') {
    startExp();
  } else if (key === 'f' || key === 'F') {
    toggleNotation();
  } else if (key === 'd' || key === 'D') {
    toggleAngle();
  }
});

updateDisplay();
