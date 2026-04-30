#pragma once
#include "Shape.h"
class Quad : public Shape
{
public:
	Quad(glm::vec3 Q, glm::vec3 u, glm::vec3 v, std::shared_ptr<Material> mat);

	void getUVS(const glm::vec3& p, float& u, float& v) const override;

	bool Intersect(const Ray& ray, float tMin, float tMax) const override;
	bool Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const override;
private:
	glm::vec3 _Q, _u, _v;
	glm::vec3 _normal;
	double _D;
	glm::vec3 _w;
};

