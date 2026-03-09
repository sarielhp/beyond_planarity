#! /bin/env julial
using Cairo, Colors

# Configuration
const N = 12
const WIDTH = 1000
const HEIGHT = 1000
const COMMON_POINT = (500.0, 500.0)

"""
Generates a random color that is bright/visible.
"""
function get_random_color()
    # Using HSV to ensure high saturation and value (brightness)
    h = rand() * 360
    return HSVA(h, 0.8, 0.9, 0.4) # 0.4 alpha for transparency
end

"""
Task 1: Random Circles containing a common point.
"""
function draw_circles(filename, format)
    surface = format == :pdf ? CairoPDFSurface(filename, WIDTH, HEIGHT) : CairoImageSurface(WIDTH, HEIGHT, Cairo.FORMAT_ARGB32)
    cr = CairoContext(surface)

    # Background
    set_source_rgb(cr, 1, 1, 1)
    paint(cr)

    for _ in 1:N
        c = get_random_color()
        
        # Determine a random center
        cx, cy = rand(200:800), rand(200:800)
        
        # Calculate distance to common point to ensure it's contained
        dist_to_point = sqrt((cx - COMMON_POINT[1])^2 + (cy - COMMON_POINT[2])^2)
        radius = dist_to_point + rand(20:100) # Ensure it covers the point + some extra

        # Draw Interior (Transparent)
        set_source_rgba(cr, c.h, c.s, c.v, 0.3) # Fill alpha
        arc(cr, cx, cy, radius, 0, 2π)
        fill_preserve(cr)

        # Draw Boundary (Opaque)
        set_source_rgba(cr, c.h, c.s, c.v, 1.0) # Boundary alpha
        set_line_width(cr, 2.0)
        stroke(cr)
    end

    # Draw the common point
    set_source_rgb(cr, 0, 0, 0)
    arc(cr, COMMON_POINT[1], COMMON_POINT[2], 5, 0, 2π)
    fill(cr)

    if format == :png
        write_to_png(surface, filename)
    end
    finish(surface)
end

"""
Task 2: Regular n-gon with all diagonals.
"""
function draw_ngon(filename, format)
    surface = format == :pdf ? CairoPDFSurface(filename, WIDTH, HEIGHT) : CairoImageSurface(WIDTH, HEIGHT, Cairo.FORMAT_ARGB32)
    cr = CairoContext(surface)

    set_source_rgb(cr, 1, 1, 1)
    paint(cr)

    center = (WIDTH/2, HEIGHT/2)
    r = 400.0
    
    # Calculate vertices
    vertices = [(center[1] + r * cos(2π * i / N), center[2] + r * sin(2π * i / N)) for i in 0:N-1]
    colors = [get_random_color() for _ in 1:N]

    # Draw all diagonals (and edges)
    set_line_width(cr, 0.5)
    for i in 1:N, j in i+1:N
        move_to(cr, vertices[i]...)
        line_to(cr, vertices[j]...)
        set_source_rgba(cr, 0.2, 0.2, 0.2, 0.5) # Thin grey lines
        stroke(cr)
    end

    # Draw vertices with specific colors
    for i in 1:N
        set_source_rgba(cr, colors[i].h, colors[i].s, colors[i].v, 1.0)
        arc(cr, vertices[i]..., 10, 0, 2π)
        fill(cr)
    end

    if format == :png
        write_to_png(surface, filename)
    end
    finish(surface)
end


function  (@main)(args)
    # Execution
    draw_circles("circles.pdf", :pdf)
    draw_circles("circles.png", :png)
    draw_ngon("ngon.pdf", :pdf)
    draw_ngon("ngon.png", :png)
    
    println("Graphics generated successfully.")
    #! /bin/env julia
    
    return  0
end
