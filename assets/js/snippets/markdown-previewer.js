const starting_markdown = `# top heading
## secondary heading
this is how [a link](https://codepen.io/klm127/pen/zYKXmRB) renders

this is how \`inline code\` renders and **here** is bold text

this is how multiline code renders:
\`\`\`
function multiline() {
 return code
}
\`\`\`

this is how a numbered list renders:
1. list item 1
1. list item 2
1. list item 3!

this is how a bulleted list renders:
- item 1
  - item 2
    - just use tabs to nest!

this is how a blockquote renders:
> blockquote

tables use the pipe symbol between columns 

column1 | col2
-| -
val1 | val2

you may also render images
![a pic](https://viralcats.net/blog/wp-content/uploads/2017/12/Mean-looking-cat-Viral-Cats-05.jpg "an evil looking cat")
`;
marked.setOptions({
  breaks: true
});

class Editor extends React.Component {
  constructor(props) {
    super(props);
    this.onChanged = this.onChanged.bind(this);
    this.state = {
      text: starting_markdown
    };
  }

  render() {
    let editor_cols = Math.round($(document).width() / 8 - 10);
    return /*#__PURE__*/React.createElement("div", {
      id: 'editor-container'
    }, /*#__PURE__*/React.createElement("h3", {
      id: 'editor-title'
    }, "Editor"), /*#__PURE__*/React.createElement("textarea", {
      id: 'editor',
      rows: 25,
      cols: editor_cols,
      onChange: this.onChanged,
      value: this.state.text
    }), this.props.cols);
  }

  componentDidMount() {
    this.onChanged({
      target: {
        value: this.state.text
      }
    });
  }

  onChanged(event) {
    this.setState({
      text: event.target.value
    });
    $("#preview").html(marked(event.target.value));
  }

}

class Preview extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const md = marked('# test');
    return /*#__PURE__*/React.createElement("div", {
      id: "preview-container"
    }, /*#__PURE__*/React.createElement("h3", {
      id: "preview-text"
    }, "Preview"), /*#__PURE__*/React.createElement("div", {
      id: "preview"
    }));
  }

}

class App extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement(Editor, null), /*#__PURE__*/React.createElement(Preview, null));
  }

}

ReactDOM.render( /*#__PURE__*/React.createElement(App, null), document.getElementById("markdown-previewer-root"));
