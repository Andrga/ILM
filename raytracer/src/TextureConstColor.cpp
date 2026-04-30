#include "TextureConstColor.h"

TextureConstColor::TextureConstColor(Color c) : _constColor(c) {
}

Color TextureConstColor::color(float u, float v) const {
	return _constColor;
}
