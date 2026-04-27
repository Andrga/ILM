#pragma once
#include <glm/vec3.hpp>
#include "Color.h"
#include "ShapeIntersection.h"
#include "Ray.hpp"

class Light {
public: 
	Light(const Color& color, float glossPower, bool projectShadows) :
		_color(color), _glossPower(glossPower), _projectShadows(projectShadows)
	{}

	virtual Color shade(Ray r, ShapeIntersection hit) = 0;

	bool projectShadows() {
		return _projectShadows;
	}

	virtual glm::vec3 shadowDir(glm::vec3 point) = 0;
protected:
	Color _color;
	float _glossPower = 100.0f;
	bool _projectShadows = true;
};

