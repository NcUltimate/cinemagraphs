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
    this.addSmoke(8)

    t1 = new TimelineMax({repeat: -1})
    t1.addCallback(this.updateSnowFlakes, 0.3, [this])
    t1.addCallback(this.updateSmoke, 0.3, [this])
  ,
  updateSnowFlakes: (cinemagraph2)->
    w = $(cinemagraph2.svgId).parent().width()
    top = cinemagraph2.svg[0][0].getBoundingClientRect().top
    cinemagraph2.addSnowFlakes(10, w, -10)

    $.each d3.selectAll('.snowflake')[0], (idx, s) ->
      s.remove() if s.getBoundingClientRect().top - top > 300
  ,
  updateSmoke: (cinemagraph2)->
    w = $(cinemagraph2.svgId).parent().width()
    top = cinemagraph2.svg[0][0].getBoundingClientRect().top
    cinemagraph2.addSmoke(8)

    $.each d3.selectAll('.smoke')[0], (idx, s) ->
      $(s).remove() if $(s).css('opacity') == '0'
  ,
  addSnowFlakes: (num, w, h)->
    data = [];
    for k in [0..num]
      x = Math.floor(Math.random() * w)
      y = Math.floor(Math.random() * h)

      radius    = Math.floor(Math.random() * 2 + 1)
      opacity   = Math.random() * 0.6 + 0.1

      data.push({
        'cx' : x,
        'cy' : y,
        'radius' : radius,
        'opacity' : opacity
      });

    circles = this.svg.selectAll('snowflake')
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

    this.initSnowPaths()
  ,
  addSmoke: (num)->
    # %circle{ cx: '605', cy: '270', fill: 'url(#smoke)', r: '10px'}
    data = [];
    for k in [0..num]
      radius    = Math.floor(Math.random() * 10 + 5)
      opacity   = Math.random() * 0.2 + 0.2

      data.push({
        'radius' : radius,
        'opacity' : opacity
      });

    circles = this.svg.selectAll('smoke')
                    .data(data)
                    .enter()
                    .append('circle')

    circles.attr('cx', 605 )
            .attr('cy', 270 )
            .attr('fill', 'url(#smoke)')
            .attr('r', (d) -> return d.radius )
            .attr('opacity', (d) -> return d.opacity)
            .classed('smoke', true)
            .classed('unrisen', true)

    this.initSmokePaths()
  ,
  initSmokePaths: ->
    cinemagraph2 = this
    $.each $('.smoke.unrisen'), (idx, s) ->
      d3.select(s).classed('unrisen', false)

      x = Math.random() * 75 - 25;
      y = Math.random() * 50 - 150;
      duration = Math.floor(Math.random() * 2 + 4)
      delay = Math.random() * 1
      t1 = new TimelineMax()
      t1.to(s, duration, {
        y: y,
        x: x,
        delay: delay,
        ease: Linear.easeNone,
        opacity: 0
      })
  ,
  initSnowPaths: ->
    cinemagraph2 = this
    $.each $('.snowflake.unfallen'), (idx, s) ->
      d3.select(s).classed('unfallen', false)

      duration = Math.floor(Math.random() * 6 + 4)
      t1 = new TimelineMax()
      t1.to(s, duration, {
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