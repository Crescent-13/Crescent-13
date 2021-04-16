/datum/ship_engine/ion
	name = "ion thruster"
	var/obj/machinery/ion_engine/thruster

/datum/ship_engine/ion/New(var/obj/machinery/_holder)
	..()
	thruster = _holder

/datum/ship_engine/ion/Destroy()
	thruster = null
	. = ..()

/datum/ship_engine/ion/get_status()
	return thruster.get_status()

/datum/ship_engine/ion/get_thrust()
	return thruster.get_thrust()

/datum/ship_engine/ion/burn()
	return thruster.burn()

/datum/ship_engine/ion/set_thrust_limit(var/new_limit)
	thruster.thrust_limit = new_limit

/datum/ship_engine/ion/get_thrust_limit()
	return thruster.thrust_limit

/datum/ship_engine/ion/is_on()
	return thruster.on && thruster.powered()

/datum/ship_engine/ion/toggle()
	thruster.on = !thruster.on

/datum/ship_engine/ion/can_burn()
	return thruster.on && thruster.powered()

/obj/machinery/ion_engine
	name = "ion propulsion device"
	desc = "An advanced ion propulsion device, using energy and minutes amount of gas to generate thrust."
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "nozzle"
	power_channel = ENVIRON
	idle_power_usage = 150
	anchored = TRUE
	// construct_state = /decl/machine_construction/default/panel_closed
	var/datum/ship_engine/ion/controller
	var/thrust_limit = 1
	var/on = 1
	var/burn_cost = 1000
	var/generated_thrust = 4

/obj/machinery/ion_engine/Initialize(mapload)
	. = ..()
	controller = new(src)

/obj/machinery/ion_engine/Destroy()
	QDEL_NULL(controller)
	. = ..()

/obj/machinery/ion_engine/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powered())
		.+= "Insufficient power to operate."

	. = jointext(.,"<br>")

/obj/machinery/ion_engine/proc/burn()
	if(!on && !powered())
		return 0
	use_power_oneoff(burn_cost)
	. = thrust_limit * generated_thrust

/obj/machinery/ion_engine/proc/get_thrust()
	return thrust_limit * generated_thrust * on

/obj/item/circuitboard/engine/ion
	name = T_BOARD("ion propulsion device")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/ion_engine
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/capacitor = 2)

//Nerfed Ion Engine for "limping" home/emergency propulsion.
/obj/machinery/ion_engine/small
	name = "backup ion propulsion device"
	desc = "A compact ion propulsion device, using energy and minute amount of gas to generate thrust for emergency maneuvers."
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "nozzle"
	power_channel = ENVIRON
	idle_power_usage = 150
	anchored = TRUE
	on = 0
	burn_cost = 5000
	generated_thrust = 0.5
