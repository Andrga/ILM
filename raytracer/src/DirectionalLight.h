#pragma once
#include "Light.h"

class DirectionalLight : public Light {
public:
	DirectionalLight(const glm::vec3& dir, const Color& color);

	Color shade(Ray r, ShapeIntersection hit) override;

private: 
	glm::vec3 _direction;
	Color _color;
	float _glossPower = 1.0f;
};

