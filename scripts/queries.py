#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
@author: Ulrike Henny-Krahmer

Basic metadata queries.
"""

import pandas as pd
import plotly.graph_objects as go
import math
from os.path import join


def plot_subgenres_by_decade(wdir, md_file, subgenre_level, outpath):
	"""
	Create a stacked bar plot showing the subgenres of a certain level (theme, current)
	by decade.
	
	Arguments:
	wdir (str): path to the working directory
	md_file (str): relative path to the metadata file
	subgenre_level (str): type of subgenre as given in the metadata table, e.g. "subgenre-theme", "subgenre-current"
	outpath (str): relative path to the output directory (where to save the plots)
	"""
	print("plot subgenres by decade (" + subgenre_level + ")...")
	
	colors_currents = {"novela romántica":"#DC3912","novela realista":"#3366CC","novela naturalista":"#109618","novela modernista":"#FF9900","unknown":"#990099"}
	
	md = pd.read_csv(join(wdir, md_file), index_col=0)

	year_min = min(md["year"])
	year_max = max(md["year"])

	decade_min = math.floor(year_min / 10) * 10
	decade_max = math.floor(year_max / 10) * 10

	x = list(range(decade_min, decade_max + 10,10))
	
	if subgenre_level == "subgenre-current":
		subgenres = ["novela romántica", "novela realista", "novela naturalista", "novela modernista", "unknown"]
	else:
		subgenres = list(md.groupby(by=subgenre_level).size().sort_values(ascending=False).index)
		
	fig = go.Figure()
	
	for sub in subgenres:
		y = []
		for dec in x:
			sub_rows = md.loc[(md[subgenre_level]==sub) & (md["year"] >= dec) & (md["year"] < (dec + 10))]
			y.append(len(sub_rows))
		if subgenre_level == "subgenre-current":
			fig.add_trace(go.Bar(name=sub,x=x,y=y,marker_color=colors_currents[sub]))
		else:
			fig.add_trace(go.Bar(name=sub,x=x,y=y))
		
	# Change the bar mode
	outfile = "bar_subgenres-by-decade_" + subgenre_level
	fig.update_layout(barmode="stack", autosize=False, width=800, height=600, title="Novels by decade and subgenre (" + subgenre_level + ")")
	fig.update_xaxes(title="decade", type="category")
	fig.update_yaxes(title="number of novels")
	fig.write_image(join(wdir, outpath, outfile + ".png")) # scale=2 (increase physical resolution)
	
	print("done: plot subgenres by decade (" + subgenre_level + ")")
	

def list_top_authors(wdir, md_file):
	"""
	List the authors with most works in the corpus
	
	Arguments:
	wdir (str): path to the working directory
	md_file (str): relative path to the metadata file
	"""
	
	md = pd.read_csv(join(wdir, md_file), index_col=0)
	authors = md.groupby(by="author-short").size().sort_values(ascending=False)
	print(authors.iloc[:20])
	
	
wdir = "/home/ulrike/Git/conha19"

#plot_subgenres_by_decade(wdir, "metadata.csv", "subgenre-theme", "plots")
#plot_subgenres_by_decade(wdir, "metadata.csv", "subgenre-current", "plots")

list_top_authors(wdir, "metadata.csv")
