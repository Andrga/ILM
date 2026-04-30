#pragma once
#include "Shape.h"
#include "Ray.hpp"
#include <glm/vec3.hpp>

#include "glm/geometric.hpp"
#include "glm/trigonometric.hpp"

class Sphere : public Shape {
public:
	Sphere(glm::vec3 center, float radius, std::shared_ptr<Material> mat);

	void getUVS(const glm::vec3& p, float& u, float& v) const override;

	glm::vec3 getCenter() const { return _center; }
	float getRadius() const { return _radius; }

	void setCenter(glm::vec3 c) { _center = c; }
	void setRadius(float r) { _radius = r; }

	bool Intersect(const Ray& ray, float tMin, float tMax) const override;
	bool Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const override;

private: 
	glm::vec3 _center;
	float _radius;
};

