using Images


function stencil(image, back, shape, scale=1.0)
	# nova imagem (tela preta)
    pixels = RGB.(zeros(size(image)))
	# largura e altura
    w, h = size(pixels)
	for j in 1:w
		for i in 1:h
			u = (2.0*((i-1)/(h-1)) - 1.0)
			v = (-2.0*((j-1)/(w-1)) + 1)
			value = shape(u, v, scale)
            # Dentro da curva, usa o pixel da imagem; fora, usa o fundo
			pixels[j, i] = value ≤ 0 ? image[j, i] : back[j, i]
		end
	end
	pixels
end

function increase(img, back, smax, smin, duration, shape, offset::Int=0; fps=30)
    # M.U.V
    a = (smax - smin)/(duration^2)
    total::Int = floor(duration*fps)
    for i in 1:total
        s = smin + a*(i/fps)^2
        frame = stencil(img, back, shape, s)
        save("output/frame$(i+offset).jpg", frame)
    end
    total + offset
end

function decrease(img, back, smax, smin, duration, shape, offset=0; fps=30)
    increase(img, back, smin, smax, duration, shape, offset, fps=fps)
end

function stillframe(img, back, s, duration, shape, offset; fps=30)
    increase(img, back, s, s, duration, shape, offset, fps=fps)
end

function beat(img, back, smax, smin, duration, shape, offset; fps=30,tbeats=3)
    off = offset
    timeperbeats = duration/tbeats
    for k in 1:tbeats
        off = increase(img, back, smax, smin, 
                        timeperbeats*0.2, shape, off, fps=fps)
        off = decrease(img, back, smax, smin, 
                        timeperbeats*0.2, shape, off, fps=fps)
        off = increase(img, back, smax, smin, 
                        timeperbeats*0.2, shape, off, fps=fps)
        off = decrease(img, back, smax, smin, 
                        timeperbeats*0.2, shape, off, fps=fps)
        off = stillframe(img, back, smin, 
                            timeperbeats*0.2, shape, off, fps=fps)
    end
    off
end

# Pequeno teste
img = ones((1080, 1080))
back = zeros((1080, 1080))
coeur(x, y, s=1.0) = (x/s)^2 + 2*((3/5)*((x/s)^2)^(1/3) - (y + 1/8)/s)^2 - 1
save("output/coracao.jpg", stencil(img, back, coeur))