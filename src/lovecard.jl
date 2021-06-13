include("stencil.jl")


coeur(x, y, s=1.0) = (x/s)^2 + 2*((3/5)*((x/s)^2)^(1/3) - (y + 1/8)/s)^2 - 1

# para o Instagram
function openimage(path)
	img = load(path)
	img = imresize(img, (1080, 1080))
end

function love_animation(smax, smin, sbeat, loveimages, back, shape=coeur)
    offset = 0
    for imgpath in loveimages
        img = openimage(imgpath)
        offset = increase(img, back, smax, smin, 2, shape, offset)
        offset = beat(img, back, sbeat, smax, 3, shape, offset)
        offset = decrease(img, back, smax, smin, 2, shape, offset)
    end
end

background = imfilter(openimage("input/back_code.png"), Kernel.gaussian(1))
loveimages = map(i -> "input/love$i.jpg", 1:2) 
love_animation(1, 1/30, 1.25, loveimages, background)
