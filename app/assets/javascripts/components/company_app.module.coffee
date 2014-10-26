# @cjsx React.DOM


People = React.createFactory(require('components/people'))


# Main
#
module.exports = React.createClass


  displayName: 'CompanyApp'
  
  
  render: ->
    <article className="editor">
      <section className="people">
        <People />
      </section>
    </article>
