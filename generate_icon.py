#!/usr/bin/env python3
from PIL import Image
import os

# Criar o diretório temporário se não existir
os.makedirs('temp_icon', exist_ok=True)

# Definir as resoluções necessárias
resolutions = {
    # Android
    'android/app/src/main/res/mipmap-mdpi': (48, 48),
    'android/app/src/main/res/mipmap-hdpi': (72, 72),
    'android/app/src/main/res/mipmap-xhdpi': (96, 96),
    'android/app/src/main/res/mipmap-xxhdpi': (144, 144),
    'android/app/src/main/res/mipmap-xxxhdpi': (192, 192),
    # iOS
    'ios/Runner/Assets.xcassets/AppIcon.appiconset': (1024, 1024),
    # Web
    'web/icons': (192, 192),
}

# Criar a imagem do vinil usando PIL (desenhar programaticamente)
def create_vinyl_icon(size):
    """Criar um ícone de vinil com as cores do Spotify"""
    img = Image.new('RGB', (size, size), color='black')
    pixels = img.load()
    
    # Centro do vinil
    center = size // 2
    
    # Desenhar círculos concêntricos (efeito de vinil)
    for i in range(size // 2):
        if i % 4 < 2:  # Faixas alternadas
            color = (30, 30, 30)
        else:
            color = (50, 50, 50)
        
        # Desenhar círculo
        for angle in range(360):
            import math
            x = int(center + i * math.cos(math.radians(angle)))
            y = int(center + i * math.sin(math.radians(angle)))
            if 0 <= x < size and 0 <= y < size:
                pixels[x, y] = color
    
    # Desenhar o disco central com cores
    inner_radius = size // 5
    for x in range(size):
        for y in range(size):
            dx = x - center
            dy = y - center
            dist = (dx*dx + dy*dy) ** 0.5
            
            if dist < inner_radius:
                # Cor branca de fundo
                pixels[x, y] = (255, 255, 255)
    
    # Desenhar a parte colorida do disco (pizza chart style)
    import math
    for x in range(size):
        for y in range(size):
            dx = x - center
            dy = y - center
            dist = (dx*dx + dy*dy) ** 0.5
            
            if dist < inner_radius * 0.9:
                angle = math.degrees(math.atan2(dy, dx)) % 360
                
                # Metade vermelha
                if angle < 180:
                    pixels[x, y] = (220, 53, 69)  # Vermelho
                # Metade amarela
                else:
                    pixels[x, y] = (255, 193, 7)  # Amarelo
    
    # Desenhar borda verde
    for x in range(size):
        for y in range(size):
            dx = x - center
            dy = y - center
            dist = (dx*dx + dy*dy) ** 0.5
            
            if inner_radius * 0.9 < dist < inner_radius * 1.05:
                pixels[x, y] = (34, 177, 76)  # Verde
    
    # Desenhar o rótulo branco interno
    label_radius = size // 10
    for x in range(size):
        for y in range(size):
            dx = x - center
            dy = y - center
            dist = (dx*dx + dy*dy) ** 0.5
            
            if dist < label_radius:
                pixels[x, y] = (255, 255, 255)
    
    # Desenhar o ponto central
    for x in range(max(0, center-2), min(size, center+3)):
        for y in range(max(0, center-2), min(size, center+3)):
            pixels[x, y] = (0, 0, 0)
    
    return img

# Gerar ícones em diferentes tamanhos
print("Gerando ícones do vinil...")

for dir_path, (width, height) in resolutions.items():
    os.makedirs(dir_path, exist_ok=True)
    
    # Criar ícone
    icon = create_vinyl_icon(width)
    
    # Salvar como icon.png
    icon_path = os.path.join(dir_path, 'ic_launcher.png' if 'android' in dir_path else 'AppIcon.png')
    icon.save(icon_path)
    print(f"✓ Criado: {icon_path} ({width}x{height})")

print("\n✓ Ícones gerados com sucesso!")
