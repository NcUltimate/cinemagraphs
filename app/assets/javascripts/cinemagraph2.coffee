$ -> Cinemagraph2.initialize('#cinemagraph2')

Cinemagraph2 = {
  svg:    undefined,
  svgId:  undefined,
  initialize: (svg) ->
    this.svgId  = svg;
    this.svg    = d3.select(svg);

    w = $(this.svgId).parent().width()
    h = $(this.svgId).parent().height()
    this.addSnowFlakes(250, w, h)
    this.initSnowPaths()

    t1 = new TimelineMax({repeat: -1})
    t1.addCallback(this.updateSnowFlakes, 0.3, [this])
  ,
  updateSnowFlakes: (cinemagraph2)->
    w = $(cinemagraph2.svgId).parent().width()
    top = cinemagraph2.svg[0][0].getBoundingClientRect().top
    cinemagraph2.addSnowFlakes(10, w, -10)
    cinemagraph2.initSnowPaths()

    $.each d3.selectAll('.snowflake')[0], (idx, s) ->
      s.remove() if s.getBoundingClientRect().top - top > 300
  ,
  addSnowFlakes: (num, w, h)->
    data = [];
    for k in [0..num]
      x = Math.floor(Math.random() * w)
      y = Math.floor(Math.random() * h)

      duration  = Math.floor(Math.random() * 2 + 2)
      radius    = Math.floor(Math.random() * 2 + 1)
      opacity   = Math.random() * 0.6 + 0.1
      delay     = Math.random() * 5

      data.push({
        'cx' : x,
        'cy' : y,
        'radius' : radius,
        'duration' : duration,
        'delay' : delay,
        'opacity' : opacity
      });

    circles = this.svg.selectAll('akjwdb')
                    .data(data)
                    .enter()
                    .append('circle')

    circles.attr('cx', (d) -> return d.cx )
            .attr('cy', (d) -> return d.cy )
            .attr('r', (d) -> return d.radius )
            .attr('fill', 'white')
            .attr('opacity', (d) -> return d.opacity)
            .classed('snowflake', true)
            .classed('unfallen', true)
  ,
  initSnowPaths: ->
    cinemagraph2 = this
    $.each $('.snowflake.unfallen'), (idx, s) ->
      d3.select(s).classed('unfallen', false)

      duration = Math.floor(Math.random() * 6 + 4)
      t1 = new TimelineMax()
      t1.to(s, duration, {
        y: 350,
        ease: Linear.easeNone,
        bezier: {
          type:"soft", 
          values: cinemagraph2.generateSnowPath(),
          curviness: 1
        }
      })
  ,
  generateSnowPath: ->
    x = 0
    y = 0
    npoints = 5
    points  = [{x:x, y:y}]
    dist    = Math.random() * 80 + 20
    for k in [0..npoints]
      rx = Math.floor(Math.random() * dist) - dist/4
      x  -= rx
      y  += 300/npoints
      points.push({x: x, y: y})
    return points

}