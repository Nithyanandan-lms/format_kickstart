<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Renderer for Kickstart format.
 *
 * @package    format_kickstart
 * @copyright  2021 bdecent gmbh <https://bdecent.de>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace format_kickstart\output;

use core_courseformat\output\section_renderer;
use format_kickstart\output\general_action_bar;
use format_kickstart\output\kickstartHandler;
use renderable;

/**
 * Renderer for the kickstart format.
 *
 * @copyright 2021 bdecent gmbh <https://bdecent.de>
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class renderer extends section_renderer {

    /**
     * Overrides the parent so that templatable widgets are handled even without their explicit render method.
     *
     * @param renderable $widget
     * @return string
     * @throws \moodle_exception
     */
    public function render(renderable $widget) {
        $namespacedclassname = get_class($widget);
        $plainclassname = preg_replace('/^.*\\\/', '', $namespacedclassname);
        $rendermethod = 'render_'.$plainclassname;

        if (method_exists($this, $rendermethod)) {
            // Explicit rendering method exists, fall back to the default behaviour.
            return parent::render($widget);
        }

        $interfaces = class_implements($namespacedclassname);

        if (isset($interfaces['templatable'])) {
            // Default implementation of template-based rendering.
            $data = $widget->export_for_template($this);
            return parent::render_from_template('format_kickstart/'.$plainclassname, $data);

        } else {
            return parent::render($widget);
        }
    }

    /**
     * Renders the action bar for a given page.
     *
     * @param general_action_bar $actionbar
     * @return string The HTML output
     */
    public function render_action_bar(general_action_bar $actionbar): string {
        $data = $actionbar->export_for_template($this);
        return $this->render_from_template($actionbar->get_template(), $data);
    }


    /**
     * Renders a kickstart page by retrieving its content.
     *
     * @param kickstartHandler $kickstartpage The kickstart page handler to render
     * @return string The rendered content of the kickstart page
     */
    public function render_kickstart_page(kickstartHandler $kickstartpage) {
        return $kickstartpage->get_content();
    }
}
