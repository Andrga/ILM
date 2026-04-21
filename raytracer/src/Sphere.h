#pragma once
#include "Shape.h"
#include "Ray.hpp"
#include <glm/vec3.hpp>

#include "glm/geometric.hpp"
#include "glm/trigonometric.hpp"
class Sphere : public Shape {
public:
	Sphere(glm::vec3 center, float radius, Material* mat);

	glm::vec3 getCenter() const { return _center; }
	float getRadius() const { return _radius; }

	void setCenter(glm::vec3 c) { _center = c; }
	void setRadius(float r) { _radius = r; }

	bool Intersect(const Ray& ray, float tMin, float tMax) const override;

private: 
	glm::vec3 _center;
	float _radius;
};

