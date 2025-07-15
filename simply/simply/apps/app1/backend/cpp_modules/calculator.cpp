#include <pybind11/pybind11.h>

namespace py = pybind11;

// Simple C++ functions to be exposed to Python
double add(double a, double b) {
    return a + b;
}

double multiply(double a, double b) {
    return a * b;
}

// Module definition
PYBIND11_MODULE(cpp_calculator, m) {
    m.doc() = "C++ calculator module"; // Optional module docstring
    
    m.def("add", &add, "Add two numbers",
          py::arg("a"), py::arg("b"));
    
    m.def("multiply", &multiply, "Multiply two numbers",
          py::arg("a"), py::arg("b"));
}
