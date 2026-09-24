#include "uxclz.h"

#include <cassert>
#include <cstdint>
#include <iostream>
#include <string>

namespace {
struct Counter { std::int64_t value; };

void UXCLZ_CALL destroy_counter(void* payload) {
    delete static_cast<Counter*>(payload);
}

int UXCLZ_CALL counter_add(uxclz_handle, void* payload, const uxclz_value* args,
                           std::uint32_t argc, uxclz_value* result) {
    if (!payload || argc != 1 || !args || args[0].kind != UXCLZ_VALUE_I64 || !result) return 0;
    auto* counter = static_cast<Counter*>(payload);
    counter->value += args[0].data.i64;
    result->kind = UXCLZ_VALUE_I64;
    result->data.i64 = counter->value;
    return 1;
}

int UXCLZ_CALL collide(uxclz_handle, void* left_payload,
                       uxclz_handle, void* right_payload,
                       const uxclz_value*, std::uint32_t, uxclz_value* result) {
    if (!left_payload || !right_payload || !result) return 0;
    result->kind = UXCLZ_VALUE_I64;
    result->data.i64 = *static_cast<int*>(left_payload) + *static_cast<int*>(right_payload);
    return 1;
}

void UXCLZ_CALL destroy_int(void* payload) { delete static_cast<int*>(payload); }
}

int main() {
    assert(uxclz_version() == 0x00010000u);
    assert(uxclz_reset_registry() == 1);

    const auto printable = uxclz_type_register("IPrintable", 0, UXCLZ_TYPE_INTERFACE);
    const auto object = uxclz_type_register("Object", 0, UXCLZ_TYPE_CLASS);
    const auto counter_type = uxclz_type_register("Counter", object, UXCLZ_TYPE_CLASS | UXCLZ_TYPE_ENTITY);
    assert(printable && object && counter_type);
    assert(uxclz_type_add_interface(counter_type, printable) == 1);
    assert(uxclz_type_is_a(counter_type, object) == 1);
    assert(uxclz_type_has_interface(counter_type, printable) == 1);
    assert(uxclz_method_register(counter_type, 1001, "Add", &counter_add) == 1);

    const auto counter = uxclz_object_wrap(counter_type, new Counter{10}, &destroy_counter);
    assert(counter != 0 && uxclz_object_is_valid(counter) == 1);
    const auto iface = uxclz_object_query_interface(counter, printable);
    assert(iface == counter);
    assert(uxclz_object_release(iface) == 1);

    const auto args = uxclz_args_new();
    const auto result = uxclz_result_new();
    assert(args && result);
    assert(uxclz_args_push_i64(args, 32) == 1);
    assert(uxclz_invoke_args(counter, 1001, args, result) == 1);
    assert(uxclz_result_kind(result) == UXCLZ_VALUE_I64);
    assert(uxclz_result_i64(result) == 42);
    uxclz_args_free(args);
    uxclz_result_free(result);

    const auto ship = uxclz_type_register("Ship", object, UXCLZ_TYPE_CLASS);
    const auto asteroid = uxclz_type_register("Asteroid", object, UXCLZ_TYPE_CLASS);
    assert(uxclz_multimethod_register(2001, ship, asteroid, "Collide", &collide) == 1);
    const auto ship_h = uxclz_object_wrap(ship, new int(7), &destroy_int);
    const auto asteroid_h = uxclz_object_wrap(asteroid, new int(35), &destroy_int);
    const auto multi_result = uxclz_result_new();
    assert(uxclz_multimethod_invoke_args(2001, ship_h, asteroid_h, 0, multi_result) == 1);
    assert(uxclz_result_i64(multi_result) == 42);
    uxclz_result_free(multi_result);

    const std::string metadata = uxclz_registry_metadata_json();
    assert(metadata.find("Counter") != std::string::npos);
    assert(metadata.find("IPrintable") != std::string::npos);

    assert(uxclz_object_release(ship_h) == 1);
    assert(uxclz_object_release(asteroid_h) == 1);
    assert(uxclz_object_release(counter) == 1);
    assert(uxclz_object_is_valid(counter) == 0);
    assert(uxclz_object_release(counter) == 0); // stale/double release must fail.
    assert(uxclz_reset_registry() == 1);

    std::cout << "UXCLZ_SMOKE_PASS value=42\n";
    return 0;
}
