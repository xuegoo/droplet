helper = require '../../src/helper.coffee'
JavaScript = require '../../src/javascript.coffee'

asyncTest 'JS dotted methods', ->
  customJS = new JavaScript({
    functions: {
      'console.log': {},
      speak: {},
      'Math.log': {
        value: true
      },
      '*.toString': {
        value: true
      },
      '?.pos': {
        command: true,
        color: 'red'
      },
      setTimeout: {
        command: true,
        value: true
      }
    }
  })

  customSerialization = customJS.parse(
    '''
    x.pos(100);
    return console.log(Math.log(log(x.toString(~pos()))));
    '''
  ).serialize()

  expectedSerialization = '''<segment
      isLassoSegment="false"><block
      precedence="2"
      color="red"
      socketLevel="0"
      classes="CallExpression mostly-block"><socket
      precedence="100"
      handwritten="false"
      classes=""
    >x</socket
    >.pos(<socket
      precedence="100"
      handwritten="false"
      classes="">100</socket>);</block>\n<block
      precedence="0"
      color="yellow"
      socketLevel="0"
      classes="ReturnStatement mostly-block"
    >return <socket
      precedence="0"
      handwritten="false"
      classes=""
    ><block
      precedence="2"
      color="blue"
      socketLevel="0"
      classes="CallExpression mostly-block"
    >console.log(<socket
      precedence="100"
      handwritten="false"
      classes=""
    ><block
      precedence="2"
      color="green"
      socketLevel="0"
      classes="CallExpression mostly-value"
    >Math.log(<socket
      precedence="100"
      handwritten="false"
      classes=""
    ><block
      precedence="2"
      color="blue"
      socketLevel="0"
      classes="CallExpression any-drop"
    ><socket
      precedence="100"
      handwritten="false"
      classes=""
    >log</socket>(<socket
      precedence="100"
      handwritten="false"
      classes=""
    ><block
      precedence="2"
      color="green"
      socketLevel="0"
      classes="CallExpression mostly-value"
    ><socket
      precedence="100"
      handwritten="false"
      classes=""
    >x</socket>.toString(<socket
      precedence="100"
      handwritten="false"
      classes=""
    ><block
      precedence="4"
      color="green"
      socketLevel="0"
      classes="UnaryExpression mostly-value"
    >~<socket
      precedence="4"
      handwritten="false"
      classes=""
    ><block
      precedence="2"
      color="red"
      socketLevel="0"
      classes="CallExpression mostly-block"
    >pos()</block></socket></block></socket
    >)</block></socket
    >)</block></socket
    >)</block></socket
    >)</block></socket
    >;</block></segment>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'Dotted known functions work')
  start()

asyncTest 'JS Custom Colors', ->
  customJS = new JavaScript({
    categories: {
      functions: {color: '#111'},
      returns: {color: '#222'},
      comments: {color: '#333'},
      arithmetic: {color: '#444'},
      containers: {color: '#666'},
      assignments: {color: '#777'},
      loops: {color: '#888'},
      conditionals: {color: '#999'},
      value: {color: '#aaa'},
      command: {color: '#bbb'}
    }
  })
  customSerialization = customJS.parse(
      'return b != (a += [c + d][0]);').serialize()
  expectedSerialization = '''<segment
      isLassoSegment="false"
    ><block
      precedence="0"
      color="#222"
      socketLevel="0"
      classes="ReturnStatement mostly-block"
    >return <socket
      precedence="0"
      handwritten="false"
      classes=""
    ><block
      precedence="9"
      color="cyan"
      socketLevel="0"
      classes="BinaryExpression mostly-value"
    ><socket
      precedence="9"
      handwritten="false"
      classes=""
    >b</socket
    > != <socket
      precedence="9"
      handwritten="false"
      classes=""
    ><block
      precedence="0"
      color="#777"
      socketLevel="0"
      classes="mostly-block AssignmentExpression"
    >(<socket
      precedence="0"
      handwritten="false"
      classes=""
    >a</socket
    > += <socket
      precedence="0"
      handwritten="false"
      classes=""
    ><block
      precedence="1"
      color="#666"
      socketLevel="0"
      classes="MemberExpression mostly-value"
    ><socket
      precedence="0"
      handwritten="false"
      classes=""
    ><block
      precedence="0"
      color="#666"
      socketLevel="0"
      classes="ArrayExpression mostly-value"
    >[<socket
      precedence="0"
      handwritten="false"
      classes=""
    ><block
      precedence="6"
      color="#444"
      socketLevel="0"
      classes="BinaryExpression mostly-value"
    ><socket
      precedence="6"
      handwritten="false"
      classes=""
    >c</socket
    > + <socket
      precedence="6"
      handwritten="false"
      classes=""
    >d</socket></block></socket
    >]</block></socket
    >[<socket
      precedence="0"
      handwritten="false"
      classes=""
    >0</socket
    >]</block></socket
    >)</block></socket></block></socket
    >;</block></segment>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'JS Custom colors work')
  start()

asyncTest 'JS empty indents', ->
  customJS = new JavaScript()
  code = 'if (__) {\n\n}'
  customSerialization = customJS.parse('if (__) {\n\n}')
  stringifiedJS = customSerialization.stringify(customJS)
  strictEqual(code, stringifiedJS)
  start()

asyncTest 'JS LogicalExpressions', ->
  customJS = new JavaScript()
  customSerialization = customJS.parse(
      'a && b').serialize()
  expectedSerialization = '''<segment
        isLassoSegment="false"
      ><block
        precedence="13"
        color="cyan"
        socketLevel="0"
        classes="LogicalExpression mostly-value"
      ><socket
        precedence="13"
        handwritten="false"
        classes=""
      >a</socket> &amp;&amp; <socket
        precedence="13"
        handwritten="false"
        classes=""
      >b</socket></block></segment>'''
  strictEqual(
      helper.xmlPrettyPrint(customSerialization),
      helper.xmlPrettyPrint(expectedSerialization),
      'Logical expression precedences are assigned.')
  start()
