var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

//x
function db(str) {
  var dbe = document.getElementById("test1");
  var dbs = dbe.innerHTML;
  dbe.innerHTML = dbs + '<br />' + str.toString();
}

var Calculator = function (_React$Component) {
  _inherits(Calculator, _React$Component);

  function Calculator(props) {
    _classCallCheck(this, Calculator);

    var _this = _possibleConstructorReturn(this, (Calculator.__proto__ || Object.getPrototypeOf(Calculator)).call(this, props));

    _this.state = {
      displayString: '0'
    };
    _this.keyTest = _this.keyTest.bind(_this);
    _this.handleClick = _this.handleClick.bind(_this);
    _this.keyDict = {
      '13': 'equals',
      '46': 'clear',
      '48': 'zero',
      '49': 'one',
      '50': 'two',
      '51': 'three',
      '52': 'four',
      '53': 'five',
      '54': 'six',
      '55': 'seven',
      '56': 'eight',
      '57': 'nine',
      '61': 'equals',
      '80': 'add',
      '88': 'multiply',
      '96': 'zero',
      '97': 'one',
      '98': 'two',
      '99': 'three',
      '100': 'four',
      '101': 'five',
      '102': 'six',
      '103': 'seven',
      '104': 'eight',
      '105': 'nine',
      '106': 'multiply',
      '107': 'add',
      '109': 'subtract',
      '110': 'decimal',
      '111': 'divide',
      '173': 'subtract',
      '191': 'divide'
    };
    _this.calc = {
      buttons: {
        'one': '1',
        'two': '2',
        'three': '3',
        'four': '4',
        'five': '5',
        'six': '6',
        'seven': '7',
        'eight': '8',
        'nine': '9',
        'zero': '0',
        'add': '+',
        'subtract': '-',
        'multiply': '*',
        'divide': '/',
        'decimal': '.'
      },
      string: '0',
      //delete debug functionality in "clear" before production
      parseButton: function parseButton(cmdName) {
        this.string = $("#display").html();
        switch (cmdName) {
          case 'clear':
            this.string = '0';
            $("#test1").html('');
            break;
          case 'one':
            this.digit(cmdName);
            break;
          case 'two':
            this.digit(cmdName);
            break;
          case 'three':
            this.digit(cmdName);
            break;
          case 'four':
            this.digit(cmdName);
            break;
          case 'five':
            this.digit(cmdName);
            break;
          case 'six':
            this.digit(cmdName);
            break;
          case 'seven':
            this.digit(cmdName);
            break;
          case 'eight':
            this.digit(cmdName);
            break;
          case 'nine':
            this.digit(cmdName);
            break;
          case 'zero':
            this.digit(cmdName);
            break;
          case 'add':
            this.operator(cmdName);
            break;
          case 'subtract':
            this.operator(cmdName);
            break;
          case 'multiply':
            this.operator(cmdName);
            break;
          case 'divide':
            this.operator(cmdName);
            break;
          case 'equals':
            this.process();
            break;
          case 'decimal':
            this.decimal(cmdName);
            break;
        }
      },
      operator: function operator(operatorName) {
        var new_op = this.buttons[operatorName];
        var indx = this.string.length - 1;
        var last_char = this.string[indx];
        if (/\d/.test(last_char)) {
          //if last character is digit, append new operator
          this.string = this.string + new_op;
          return;
        } else {
          //last character is not a digit(must be an operator)
          if (new_op == '+' || new_op == '*' || new_op == '/') {
            this.string = this.string.slice(0, indx); //cut off the last digit
            this.operator(operatorName); // call this function again
            return;
          } else if (new_op == '-') {
            if (last_char == '+') {
              // replace + with -
              this.string = this.string.slice(0, indx) + new_op;
              return;
            } else if (last_char == '*' || last_char == '/') {
              this.string = this.string + new_op;
              return;
            }
          }
        }
      },
      digit: function digit(digitName) {
        if (this.string == '0') {
          this.string = this.buttons[digitName];
        } else {
          this.string = this.string + this.buttons[digitName];
        }
      },
      decimal: function decimal(operatorName) {
        if (/[^\.]\d+$/.test(this.string) || this.string.length == 1) {
          this.string += '.';
        } else {
          var test_char = this.string[this.string.length - 1];
          if (/[^\d\.]/.test(test_char)) {
            this.string += '0.';
          }
        }
      },
      process: function process() {
        function tokenize(str) {
          function convert(match) {
            if (/[+\/*]/.test(match)) {
              return match; //operator - stays a string
            } else if (/\d+\.\d+/.test(match)) {
              //it's a decimal
              return parseFloat(match);
            } else {
              return parseInt(match); //if its not an operator or decimal, it must be anint.
            }
          }
          //old regex: /((\d+\.*)+)|([+\-*\/]+)/g   didn't handle preceding negatives
          var tokens = [];
          var token_finder = /(\-?\d+(\.\d+)?)|([\+*\/])/g;
          var results = [].concat(_toConsumableArray(str.matchAll(token_finder)));
          for (var i = 0; i < results.length; i++) {
            var r = convert(results[i][0]);
            if (r < 0) {
              if (i < 1) {
                tokens.push(0);
                tokens.push('+');
              } else {
                var last = tokens[tokens.length - 1];
                if ((typeof last === 'undefined' ? 'undefined' : _typeof(last)) != _typeof('string')) {
                  tokens.push('+');
                }
              }
            }
            //db('calced result: ' + r);     
            tokens.push(r);
          }
          //db('tokens final: ' + tokens.join(' , '));
          return tokens;
        }
        function operate(operator, tokens) {
          for (var i = 0; i < tokens.length; i++) {
            if (tokens[i] == operator) {
              var left = tokens[i - 1];
              var right = tokens[i + 1];
              var result = 0;
              switch (operator) {
                case '+':
                  result = left + right;
                  break;
                case '*':
                  result = left * right;
                  break;
                case '/':
                  result = left / right;
                  break;
              }
              tokens = [].concat(_toConsumableArray(tokens.slice(0, i - 1)), [result], _toConsumableArray(tokens.slice(i + 2, tokens.length)));
              //db('tokens current: ' + tokens.join(' , '));
            }
          }
          return tokens;
        }
        var tokens = tokenize(this.string);
        var ensureNoLoop = 100;
        while (tokens.length > 1 && ensureNoLoop > 0) {
          tokens = operate('*', tokens);
          tokens = operate('/', tokens);
          tokens = operate('+', tokens);
          tokens = operate('-', tokens);
          ensureNoLoop--;7;
        }
        this.string = tokens[0];
        //db(this.string);
        //multiply
      }
    };
    return _this;
  }

  _createClass(Calculator, [{
    key: 'render',
    value: function render() {
      var buttons = [{}, {}];
      return React.createElement(
        'div',
        { id: 'calculator' },
        React.createElement(
          'div',
          { id: 'display-container' },
          React.createElement(
            'div',
            { id: 'display' },
            this.state.displayString
          )
        ),
        React.createElement(
          'div',
          { id: 'buttons-container' },
          React.createElement(
            'div',
            { id: 'buttons-left' },
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'seven', onClick: this.handleClick },
              '7'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'eight', onClick: this.handleClick },
              '8'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'nine', onClick: this.handleClick },
              '9'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'four', onClick: this.handleClick },
              '4'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'five', onClick: this.handleClick },
              '5'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'six', onClick: this.handleClick },
              '6'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'one', onClick: this.handleClick },
              '1'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'two', onClick: this.handleClick },
              '2'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'three', onClick: this.handleClick },
              '3'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'zero', onClick: this.handleClick },
              '0'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'decimal', onClick: this.handleClick },
              '.'
            ),
            React.createElement(
              'div',
              { 'class': 'btn num-button', id: 'equals', onClick: this.handleClick },
              '='
            )
          ),
          React.createElement(
            'div',
            { id: 'buttons-right' },
            React.createElement(
              'div',
              { 'class': 'btn operator-button', id: 'divide', onClick: this.handleClick },
              '/'
            ),
            React.createElement(
              'div',
              { 'class': 'btn operator-button', id: 'clear', onClick: this.handleClick },
              'clr'
            ),
            React.createElement(
              'div',
              { 'class': 'btn operator-button', id: 'multiply', onClick: this.handleClick },
              '*'
            ),
            React.createElement(
              'div',
              { 'class': 'btn operator-button', id: 'subtract', onClick: this.handleClick },
              '-'
            ),
            React.createElement(
              'div',
              { 'class': 'btn operator-button plus-button', id: 'add', onClick: this.handleClick },
              '+'
            )
          )
        )
      );
    }
  }, {
    key: 'componentDidMount',
    value: function componentDidMount() {
      document.addEventListener('keydown', this.keyTest);
    }
  }, {
    key: 'componentWillUnmount',
    value: function componentWillUnmount() {
      document.removeEventListener('keydown', this.keyTest);
    }
  }, {
    key: 'keyTest',
    value: function keyTest(event) {
      var targ = this.keyDict[event.keyCode];
      if (targ == null) {
        //db('no keydict');
      } else {
        $("#" + targ).addClass('active');
        var skelvent = {
          target: { id: targ }
        };
        this.handleClick(skelvent);
        $("#" + targ).addClass('active');
      }
    }
  }, {
    key: 'handleClick',
    value: function handleClick(event) {
      $(".btn").removeClass('active');
      this.calc.parseButton(event.target.id);
      this.setState({
        displayString: this.calc.string
      });
    }
  }]);

  return Calculator;
}(React.Component);

ReactDOM.render(React.createElement(Calculator, null), document.getElementById("calculator-root"));
