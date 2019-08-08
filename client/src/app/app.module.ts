import { BrowserModule } from "@angular/platform-browser";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { HttpModule } from "@angular/http";
import { AppComponent } from "./app.component";
import { ChartModule } from "angular2-highcharts/index";
import { HighchartsStatic } from "angular2-highcharts/dist/HighchartsService";

export declare let require: any;

export function highchartsFactory() {
  const hc = require("highcharts/highstock");
  const dd = require("highcharts/modules/exporting");
  dd(hc);

  return hc;
}

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    // ChartModule.forRoot(require('highcharts/highstock')),
    ChartModule
  ],
  providers: [
    {
      provide: HighchartsStatic,
      useFactory: highchartsFactory
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule {}
