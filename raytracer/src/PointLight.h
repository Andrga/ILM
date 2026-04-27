#pragma once
#include "Light.h"

class PointLight : public Light
{
public:
	PointLight(const glm::vec3& point, const Color& color, float glossPower = 100.0f, bool projectShadows = true);

	Color shade(Ray r, ShapeIntersection hit) override;
	glm::vec3 shadowDir(glm::vec3 point) override;

private:
	glm::vec3 _point;
};



