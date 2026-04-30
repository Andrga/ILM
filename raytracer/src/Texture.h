#pragma once
#include "Color.h"

class Texture {
public:
	virtual Color color(float u, float v) const = 0;
};

