#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
@author: Ulrike Henny-Krahmer

Basic metadata queries for conha19.
"""

import pandas as pd
import plotly.graph_objects as go
import math
from os.path import join




def get_decades(md):
	"""
	Get the list of decades covered by the publication years of the novels.
	
	Arguments:
	md (data frame): frame containing the corpus metadata
	"""

	year_min = min(md["year"])
	year_max = max(md["year"])

	decade_min = math.floor(year_min / 10) * 10
	decade_max = math.floor(year_max / 10) * 10

	x = list(range(decade_min, decade_max + 10,10))
	
	return x




def plot_novels_by_decade_country(wdir, md_file, outpath):
	"""
	Create a stacked bar chart showing the novels by country and decade.
	
	Arguments:
	wdir (str): path to the working directory
	md_file (str): relative path to the metadata file
	outpath (str): relative path to the output directory (where to save the plots)
	"""
	print("plot novels by decade and country...")
	
	md = pd.read_csv(join(wdir, md_file), index_col=0)

	x = get_decades(md)
	countries = list(md.groupby(by="country").size().sort_values(ascending=False).index)
	
	colors = {"Mexico":"#109618", "Argentina":"#3366CC","Cuba": "#DC3912"}
	
	
	fig = go.Figure()
	for c in countries:
		y = []
		for dec in x:
			c_rows = md.loc[(md["country"]==c) & (md["year"] >= dec) & (md["year"] < (dec + 10))]
			y.append(len(c_rows))
		fig.add_trace(go.Bar(name=c,x=x,y=y,marker_color=colors[c]))
	
	# settings for the figure
	outfile = "bar_novels-by-decade_country"
	fig.update_layout(barmode="stack", autosize=False, width=800, height=600, title="Novels by decade and country", legend=dict(orientation="h",font=dict(size=16)), font=dict(size=14))
	fig.update_xaxes(title="decade", type="category")
	fig.update_yaxes(title="number of novels")
	fig.write_image(join(wdir, outpath, outfile + ".png")) # scale=2 (increase physical resolution)
	
	print("done: plot novels by decade and country")
	
	
	

def plot_novels_by_decade_subgenre(wdir, md_file, subgenre_level, outpath):
	"""
	Create a stacked bar plot showing the subgenres of a certain level (theme, current)
	by decade.
	
	Arguments:
	wdir (str): path to the working directory
	md_file (str): relative path to the metadata file
	subgenre_level (str): type of subgenre as given in the metadata table, e.g. "subgenre-theme", "subgenre-current"
	outpath (str): relative path to the output directory (where to save the plots)
	"""
	print("plot novels by decade (" + subgenre_level + ")...")
	
	colors_currents = {"novela romántica":"#DC3912","novela realista":"#3366CC","novela naturalista":"#109618","novela modernista":"#FF9900","unknown":"#BBBBBB"}
	colors_theme = {"novela histórica":"#3366CC","novela sentimental":"#DC3912","novela de costumbres":"#109618","novela social":"orange","novela política":"purple","other":"#BBBBBB"}
	
	md = pd.read_csv(join(wdir, md_file), index_col=0)

	x = get_decades(md)
	
	if subgenre_level == "subgenre-current":
		subgenres = ["novela romántica", "novela realista", "novela naturalista", "novela modernista", "unknown"]
	else:
		subgenres = list(md.groupby(by=subgenre_level).size().sort_values(ascending=False).index)
		
		
	fig = go.Figure()
	
	others = []
	
	for num,sub in enumerate(subgenres):
		
		y = []
		for dec in x:
			sub_rows = md.loc[(md[subgenre_level]==sub) & (md["year"] >= dec) & (md["year"] < (dec + 10))]
			y.append(len(sub_rows))
		# set special colors for literary currents
		if subgenre_level == "subgenre-current":
			fig.add_trace(go.Bar(name=sub,x=x,y=y,marker_color=colors_currents[sub]))
		# add thematic subgenres with low quantities to "other"
		elif num > 4:
			others.append(y)
		else:
			fig.add_trace(go.Bar(name=sub,x=x,y=y,marker_color=colors_theme[sub]))
	
	if subgenre_level == "subgenre-theme":
		others = [sum(i) for i in zip(*others)]
	
		fig.add_trace(go.Bar(name="other",x=x,y=others,marker_color=colors_theme["other"]))
			
		
	# Settings for the figure
	if subgenre_level == "subgenre-theme":
		fig_title = "Novels by decade and thematic subgenre"
		outfile = "bar_novels-by-decade_subgenre-theme"
	else:
		fig_title = "Novels by decade and literary current"
		outfile = "bar_novels-by-decade_literary-current"
		
	fig.update_layout(barmode="stack", autosize=False, width=800, height=600, title=fig_title)
	fig.update_xaxes(title="decade", type="category")
	fig.update_yaxes(title="number of novels")
	fig.write_image(join(wdir, outpath, outfile + ".png")) # scale=2 (increase physical resolution)
	
	#fig.show()
	
	print("done: plot novels by decade (" + subgenre_level + ")")
	
	
	

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
	
	
	
######## MAIN ########	
	
wdir = "/home/ulrike/Git/conha19"


plot_novels_by_decade_country(wdir, "metadata_all.csv", "plots")

#plot_novels_by_decade_subgenre(wdir, "metadata.csv", "subgenre-theme", "plots")
#plot_novels_by_decade_subgenre(wdir, "metadata.csv", "subgenre-current", "plots")

#list_top_authors(wdir, "metadata.csv")
