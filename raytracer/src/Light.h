#pragma once
#include <glm/vec3.hpp>
#include "Color.h"
#include "ShapeIntersection.h"
#include "Ray.hpp"

class Light {
public: 
	virtual Color shade(Ray r, ShapeIntersection hit) = 0;
};

