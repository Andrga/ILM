#pragma once
#include <memory>

#include "Material.h"
#include "Ray.hpp"
#include "ShapeIntersection.h"

class Shape {
public:
	Shape();
	Shape(std::shared_ptr<Material> mat);
	virtual bool Intersect(const Ray& ray, float tMin, float tMax) const = 0;
	virtual bool Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const = 0;
	void setMaterial(std::shared_ptr<Material> mat) {
		_material = mat;
	}
	std::shared_ptr<Material> getMaterial() const {
		return _material;
	}
protected:
	std::shared_ptr<Material> _material;
};

