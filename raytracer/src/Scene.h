#pragma once
#include <vector>

#include "Shape.h"

class Scene : public Shape
{
public:
	Scene();
	void addShape(std::shared_ptr<Shape> const& shape);

	void getUVS(const glm::vec3& p, float& u, float& v) const override { }

	bool Intersect(const Ray& ray, float tMin, float tMax) const override;
	bool Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const override;
private:
	std::vector<std::shared_ptr<Shape>> _shapes;
};


