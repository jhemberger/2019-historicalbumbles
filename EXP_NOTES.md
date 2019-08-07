# Historical Ag and Bumble Bee Community/Abundance Changes
## Daily working notes and ideas

#### Summary Figures To Make: 

#### Data Checking


#### Data Cleanup



#### Notes
__January 7, 2018:__ Starting the initial data cleanup.  First step is to get all of the bumble bee ID's into the same format/tidy.  All 3 databases have entirely different data structure/organization.

New data frame columns: 
* `unique.id`
* `og_database`
* `database_id_1`
* `database_id_2`
* `database_id_3`
* `phylum` 
* `class`
* `order`
* `family`
* `genus` 
* `species` 
* `id_to_taxon`
* `sci_name`
* `country`
* `state`
* `county`
* `locality`
* `dec_lat`
* `dec_long`
* `elevation`
* `date` 
* `day`
* `month`
* `year` 
* `institution_code`
* `database_notes_1`
* `database_notes_2`
* `database_notes_3`

__January 8, 2019:__ Initial data cleanup is done.  Confined to lower 48 states, but did not include the IRC specimens yet as the data are horridly messy and need a lot of cleaning up.  Temporal trends in collection events actually look pretty good.  Well over 10000/decade from 1900 onward.  Today, need to clean up and do basic summary of ag data, along with some more basic summaries of bumble bees.  

STill some big differences in collection number per decade - perhaps randomly sample 

__January 14, 2019:__ Back-calculate total county area for all counties. Beyond 1997, will need to hand-calculate proportion of improved farmland from CDL (I think, unless additional data are out there)...

__April 23, 2019:__ Back again while abundance modeling is on hold for a bit! Goals are as follows: 
- [x] Relative changes by period for all spp. 
- [ ] Trait database based on Wood 2019 and others.  
- [x] Geographic scope of paper - entire US, or just eastern US?  May need some expertise help for the western bumble bee spp. and their traits, status, etc. 

__May 9, 2019:__ Issues with GBIF database found.  Apparently, there are records for vosnesenskii being in Illiois and WI?  I think the issue is that the specimens are in databases/collections in those places, but the collections obviously occurred elsewhere.  How to fix? Looks like there's a "basis of record" field in the GBIF data that could help filter out those? 

What constitutes "historical" vs. "contemporary" records?  Most papers it's a 2000 cutoff.  When are declines actually ocurring?  This really argues for looking at changes on a decadal manner to actually "see" changes in spp. composition and abundance, however I don't think we have the data to do so.  Need to check and see. Currently, my cutoff between historical and contemporary is 1970.  

__June 5, 2019:__ Fixed above issues by filtering only species known to be present in the upper midwest.  Also switched  to using a 2000 cutoff for contemporary vs. historical records.  I also plan to create a 4 category category, as well. 

__August 7, 2019:__ As of today, have rough trends in diversity and abundance done.  Now time to actually model change in those metrics as a function of agricultural area/itensity.  Will start by just using the agstat from USDA ag census, and will implement corn yields (bushels/acre) as well as a better metric of "intensity".  See paper by Shriar (2000) on the measurement of ag intensity.  

- change in geographic range?  Similar to Wood et al. (2019)
- use of traits (e.g., tongue length)? 


