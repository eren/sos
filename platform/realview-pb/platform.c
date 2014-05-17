/*
 * Copyright (C) 2013  Eren Türkay <turkay.eren@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#ifndef __PLATFORM_C
#define __PLATFORM_C

#include <debug.h>          // for dprintf
#include <platform.h>       // declares platform_init
#include "platform_ext.h"   // declares platform_init_interrupts

void platform_init()
{
    dprintf(DEBUG, "platform_init: initializing interrupts\n");
    platform_init_interrupts();
    dprintf(DEBUG, "platform_init: finished initializing interrupts\n");
}

#endif /* __PLATFORM_C */
