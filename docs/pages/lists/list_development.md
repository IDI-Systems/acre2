---
title: Development Pages
search: exclude
permalink: list_development.html
folder: lists
---

{% include custom/sidebarconfigs.html %}

<ul>
    {% for entry in sidebar %}
        {% for folder in entry.folders %}
            {% if folder.title == "Development" %}
                {% for page in folder.folderitems %}
                    <li><a href="{{ page.url | remove: "/" }}">{{page.title}}</a></li>
                {% endfor %}
            {% endif %}
        {% endfor %}
    {% endfor %}
</ul>

{% include links.html %}
