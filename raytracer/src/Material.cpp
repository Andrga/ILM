#include "Material.h"

Material::Material(Color const& baseColor, float reflexFactor) 
	: _baseColor(baseColor), _texture(nullptr), _reflexFactor(reflexFactor) {
}

Material::Material(Texture* tex, float reflexFactor) 
	: _texture(tex), _baseColor(WHITE), _reflexFactor(reflexFactor) 
{
}
