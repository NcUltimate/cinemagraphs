$ -> Cinemagraph1.initialize('#cinemagraph1')

Cinemagraph1 = {
  svg:    undefined,
  svgId:  undefined,

  initialize: (svg) ->
    this.svgId  = svg
    this.svg    = d3.select(svg)
    this.addFireflies()

    $fireflies  = $('.firefly')
    world1      = this
    $.each $fireflies, (idx, f) ->
      points    = world1.randomPoints()
      t1        = new TimelineMax({repeat: -1})
      duration  = Math.floor(Math.random() * 4 + 16)
      opacity   = Math.random() * 1
      delay     = Math.random() * 0.2
      t1.from(f, duration, {
        repeat: -1,
        yoyo: true,
        ease: Linear.easeNone,
        delay: delay,
        bezier: {
          type:"soft", 
          values: points,
          curviness: 1
        }
      })
    this.initAmbience($fireflies)
  ,
  initAmbience: ($fireflies)->
    period = 12
    t1 = new TimelineMax({repeat: -1})
    t1.from($('#sunray, #sunspot, #ambient'), period, {
      repeat: -1,
      yoyo: true,
      ease: Linear.easeNone,
      opacity: 0,
      delay: 0
    })
    t2 = new TimelineMax({repeat: -1})
    t2.to($('#nighttime'), period, {
      repeat: -1,
      yoyo: true,
      ease: Linear.easeNone,
      opacity: 0
    })
    t3 = new TimelineMax({repeat: -1})
    t3.to($fireflies, period/4, {
      ease: Linear.easeNone,
      scale: 0,
      delay: period/2
    })
    t3.to('', period/4, {})
    t3.to($fireflies, period/4, {
      ease: Linear.easeNone,
      scale: 1,
      delay: period/2
    })
    t3.to('', period/4, {})
  ,
  addFireflies: ->
    data = [];
    for k in [0..100]
      x = Math.floor(Math.random() * $(this.svgId).parent().width())
      y = Math.floor(Math.random() * $(this.svgId).parent().height())
      r = Math.floor(Math.random() * 3 + 1)

      duration  = Math.floor(Math.random() * 2 + 2)
      delay     = Math.random() * 5

      data.push({
        'cx' : x,
        'cy' : y,
        'r' : r,
        'duration' : duration,
        'delay' : delay
      });

    circles = this.svg.selectAll('circle')
                    .data(data)
                    .enter()
                    .append('circle')

    circles.attr('cx', (d) -> return d.cx )
            .attr('cy', (d) -> return d.cy )
            .attr('r', (d) -> return d.r )
            .attr('fill', 'url(#firefly_light)')
            .classed('firefly', true)
            .style('animation', (d) -> 
              return 'glow '+d.duration+'s ease-in-out '+d.delay+'s infinite'
            )
  ,
  randomPoints: ->
    radius  = 100
    npoints = Math.floor(Math.random() * 5 + 6)
    points  = []
    for k in [0..npoints]
      x = Math.floor(Math.random() * radius) - radius/2
      y = Math.floor(Math.random() * radius) - radius/2
      points.push({x: x, y: y})
    points.push({x:0, y:0})
    return points
}