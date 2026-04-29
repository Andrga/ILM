#pragma once
#include "Shape.h"
class Quad : public Shape
{
public:
	Quad(glm::vec3 Q, glm::vec3 u, glm::vec3 v, std::shared_ptr<Material> mat);

	bool Intersect(const Ray& ray, float tMin, float tMax) const override;
	bool Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const override;
	bool isInterior(float a, float b) const;
private:
	glm::vec3 _Q, _u, _v;
	glm::vec3 _normal;
	double _D;
	glm::vec3 _w;
};

