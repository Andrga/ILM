#define _USE_MATH_DEFINES
#include "Camera.hpp"
#include "glm/geometric.hpp"
#include "glm/trigonometric.hpp"
#include "random"
#include <cmath>

Camera::Camera(
	const Film& film,
	glm::vec3 position,
	glm::vec3 look,
	glm::vec3 up,
	const float fov_degrees_vertical,
	float ba
) : position(position), blurAngle(ba) {
	const float fov_radians_vertical = glm::radians(fov_degrees_vertical * 0.5);
	const float half_height_normalized = std::tan(fov_radians_vertical);

	// Calculate the u,v,w unit basis vectors for the camera coordinate frame.
	const glm::vec3 forward_displacement = position - look;
	focalLength = glm::length(forward_displacement);
	const glm::vec3 w = forward_displacement / focalLength;
	const glm::vec3 u = glm::cross(up, w);
	const glm::vec3 v = glm::cross(w, u);

	// Determine viewport dimensions.
	const float half_height_viewport = focalLength * half_height_normalized;
	const float half_width_viewport = half_height_viewport * film.GetAspectRatio();

	const float height_viewport = half_height_viewport * 2.0;
	const float width_viewport = half_width_viewport * 2.0;

	const float pixel_height = height_viewport / float(film.GetTamY());
	const float pixel_width = width_viewport / float(film.GetTamX());

	// Calculate the horizontal and vertical delta vectors to the next pixel.
	delta_x = u * pixel_width;
	delta_y = -v * pixel_height;

	// Calculate the location of the upper left pixel.
	position_top_left =
		position - focalLength * w
		+ v * half_height_viewport + delta_x * 0.5f
		- u * half_width_viewport + delta_y * 0.5f;

	//// cosas del blur
	//auto blurRadius = focalLength * glm::tan(glm::radians(blurAngle) / 2);
	//blurU = glm::normalize(u) * blurRadius;
	//blurV = glm::normalize(v) * blurRadius;

	// Calculate the camera defocus disk basis vectors.
	auto defocus_radius = focalLength * std::tan(glm::radians(blurAngle / 2));
	blurU = u * defocus_radius;
	blurV = v * defocus_radius;
}

Ray Camera::get_ray(int x, int y) const {
	const glm::vec3 sample =
		position_top_left + delta_x * (float)x + delta_y * (float)y;
	//const glm::vec3 displacement = (sample - position);

	// cosas del blur
	glm::vec3 p = randomPointInCircle( 1.0f);
	glm::vec3 origin = /*(blurAngle <= 0) ? position :*/
		position
		+ p.x * blurU
		+ p.y * blurV;
	glm::vec3 dir = sample - origin;

	return Ray{ origin, glm::normalize(dir) };
}

glm::vec3 Camera::randomPointInCircle(float radius) const {
	static std::mt19937 rng(std::random_device{}());
	static std::uniform_real_distribution<float> dist(0.0f, 1.0f);

	float randomDir = std::sqrt(dist(rng)) * 2 * M_PI; // [0, 360] en radianes
	float randomDist = std::sqrt(dist(rng)) * radius; // [0, maxRadius]

	return glm::vec3(
		glm::cos(randomDir) * randomDist,
		glm::sin(randomDir) * randomDist,
		0.0f);
}